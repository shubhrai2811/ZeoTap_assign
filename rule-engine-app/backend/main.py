from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from backend.models import Rule, Node, UserData
from backend.database import supabase
import json

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

def parse_rule(rule_string: str) -> Node:
    tokens = rule_string.split()
    return build_ast(tokens)

def build_ast(tokens):
    if len(tokens) == 1:
        return Node(type="operand", value=tokens[0])
    elif len(tokens) == 3:
        return Node(type="operator", value=tokens[1], 
                    left=Node(type="operand", value=tokens[0]),
                    right=Node(type="operand", value=tokens[2]))
    elif "AND" in tokens:
        index = tokens.index("AND")
        return Node(type="operator", value="AND",
                    left=build_ast(tokens[:index]),
                    right=build_ast(tokens[index+1:]))
    elif "OR" in tokens:
        index = tokens.index("OR")
        return Node(type="operator", value="OR",
                    left=build_ast(tokens[:index]),
                    right=build_ast(tokens[index+1:]))
    else:
        raise ValueError("Invalid rule string")

def evaluate_ast(node: Node, user_data: UserData) -> bool:
    if node.type == "operand":
        return evaluate_condition(node.value, user_data)
    elif node.type == "operator":
        if node.value == "AND":
            return evaluate_ast(node.left, user_data) and evaluate_ast(node.right, user_data)
        elif node.value == "OR":
            return evaluate_ast(node.left, user_data) or evaluate_ast(node.right, user_data)
        elif node.value in [">", "<", "==", "!="]:
            return evaluate_condition(f"{node.left.value} {node.value} {node.right.value}", user_data)
    raise ValueError(f"Invalid node type or operator: {node.type}, {node.value}")

def evaluate_condition(condition: str, user_data: UserData) -> bool:
    attribute, operator, value = condition.split()
    user_value = getattr(user_data, attribute)
    
    if operator == ">":
        return user_value > int(value)
    elif operator == "<":
        return user_value < int(value)
    elif operator == "==":
        return str(user_value) == value
    elif operator == "!=":
        return str(user_value) != value
    else:
        raise ValueError(f"Unsupported operator: {operator}")

@app.post("/rules/create")
async def create_rule(rule: Rule):
    rule_data = {
        "name": rule.name,
        "ast": json.dumps(rule.ast.dict())
    }
    result = supabase.table("rules").insert(rule_data).execute()
    return {"message": "Rule created successfully", "rule_id": result.data[0]["id"]}

@app.post("/rules/evaluate")
async def evaluate_rule(rule_id: int, user_data: UserData):
    result = supabase.table("rules").select("ast").eq("id", rule_id).execute()
    if not result.data:
        raise HTTPException(status_code=404, detail="Rule not found")
    
    ast = json.loads(result.data[0]["ast"])
    evaluation_result = evaluate_ast(Node(**ast), user_data)
    return {"result": evaluation_result}

@app.get("/rules")
async def get_rules():
    result = supabase.table("rules").select("id", "name").execute()
    return result.data

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
