# Rule Engine Application

This is a sophisticated 3-tier rule engine application that determines user eligibility based on attributes like age, department, income, and experience.

## Setup Instructions

### Backend (FastAPI)

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Install dependencies:
   ```
   pip install -r requirements.txt
   ```


3. Run the FastAPI server:
   ```
   uvicorn main:app --reload
   ```

### Frontend (Flutter)

1. Navigate to the frontend directory:
   ```
   cd frontend
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the Flutter app:
   ```
   flutter run
   ```

## Testing

1. Generate sample user data:
   ```
   python backend/generate_data.py
   ```

2. Use the generated `sample_users.json` file to test the rule evaluation functionality.

3. Backend API Testing:
   - To test rule creation:
     ```
     python backend/test_create.py
     ```
   - To test rule evaluation:
     ```
     python backend/test_eval.py
     ```
   - To test retrieving all rules:
     ```
     python backend/test_get.py
     ```

## API Endpoints

- POST /rules/create: Create a new rule
- POST /rules/evaluate: Evaluate a rule for a given user
- GET /rules: Get all rules

## Database Schema

The `rules` table in Supabase has the following structure:

- id: SERIAL PRIMARY KEY
- name: TEXT NOT NULL
- ast: JSONB NOT NULL

## Code Structure

### Backend

The main backend logic is implemented in `main.py`:
```
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from backend.models import Rule, Node, UserData
from backend.database import supabase
import json
app = FastAPI()
app = FastAPI()
def parse_rule(rule_string: str) -> Node:
# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)
    # This is a placeholder implementation
def parse_rule(rule_string: str) -> Node:
    tokens = rule_string.split()
    return build_ast(tokens)
async def create_rule(rule: Rule):
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
        elif node.value in [">", "<", "==", "!="]:
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
        return str(user_value) != value
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
async def evaluate_rule(rule_id: int, user_data: UserData):
@app.post("/rules/create")
async def create_rule(rule: Rule):
    rule_data = {
        "name": rule.name,
        "ast": json.dumps(rule.ast.dict())
    }
    result = supabase.table("rules").insert(rule_data).execute()
    return {"message": "Rule created successfully", "rule_id": result.data[0]["id"]}
@app.get("/rules")
@app.post("/rules/evaluate")
async def evaluate_rule(rule_id: int, user_data: UserData):
    result = supabase.table("rules").select("ast").eq("id", rule_id).execute()
    if not result.data:
        raise HTTPException(status_code=404, detail="Rule not found")
    
    ast = json.loads(result.data[0]["ast"])
    evaluation_result = evaluate_ast(Node(**ast), user_data)
    return {"result": evaluation_result}
    user_value = getattr(user_data, attribute)
@app.get("/rules")
async def get_rules():
    result = supabase.table("rules").select("id", "name").execute()
    return result.data
    elif operator == "<":
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)


```

Key components:
- FastAPI app setup with CORS middleware
- Rule parsing and AST construction
- Rule creation, evaluation, and retrieval endpoints
- Integration with Supabase for data persistence

### Frontend

The frontend is built using Flutter, with the main logic in `main.dart`:

```
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rule Engine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RuleEnginePage(),
    );
  }
}

class RuleEnginePage extends StatefulWidget {
  @override
  _RuleEnginePageState createState() => _RuleEnginePageState();
}

class _RuleEnginePageState extends State<RuleEnginePage> {
  final _formKey = GlobalKey<FormState>();
  String _ruleName = '';
  String _ruleString = '';
  String _result = '';
  List<dynamic> _rules = [];
  int? _selectedRuleId;
  Map<String, dynamic> _userData = {
    'age': 0,
    'department': '',
    'salary': 0,
    'experience': 0
  };
      }),
  @override
  void initState() {
    super.initState();
    _fetchRules();
  }
      });
  Future<void> _createRule() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/rules/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': _ruleName,
        'ast': {'type': 'operand', 'value': _ruleString}
      }),
    );
    return Scaffold(
    if (response.statusCode == 200) {
      setState(() {
        _result = 'Rule created successfully';
      });
      _fetchRules();
    } else {
      setState(() {
        _result = 'Failed to create rule';
      });
    }
  }
                onSaved: (value) => _ruleName = value!,
  Future<void> _fetchRules() async {
    final response = await http.get(Uri.parse('http://localhost:8000/rules'));
    if (response.statusCode == 200) {
      setState(() {
        _rules = json.decode(response.body);
        if (_rules.isNotEmpty && _selectedRuleId == null) {
          _selectedRuleId = _rules[0]['id'];
        }
      });
    }
                  }
                },
  Future<void> _evaluateRule() async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/rules/evaluate?rule_id=$_selectedRuleId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_userData),
    );
        ),
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _result = 'Rule evaluation result: ${result['result']}';
      });
    } else {
      setState(() {
        _result = 'Failed to evaluate rule';
      });
    }
  }
      setState(() {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rule Engine'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Rule Name'),
              onChanged: (value) => _ruleName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Rule String'),
              onChanged: (value) => _ruleString = value,
            ),
            ElevatedButton(
              onPressed: _createRule,
              child: Text('Create Rule'),
            ),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: _selectedRuleId,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedRuleId = newValue;
                });
              },
              items: _rules.map<DropdownMenuItem<int>>((dynamic rule) {
                return DropdownMenuItem<int>(
                  value: rule['id'],
                  child: Text(rule['name']),
                );
              }).toList(),
            ),
            TextField(
              decoration: InputDe
              keyboardType: TextInputType.number,
              onChanged: (value) => _userData['salary'] = int.tryParse(value) ?? 0,
            ),
            ElevatedButton(
              onPressed: _evaluateRule,
              child: Text('Evaluate Rule'),
            ),
            SizedBox(height: 20),
            Text(_result),
          ],
            ),
      ),
    );
  }
}

```


Key components:
- Material app setup
- Stateful widget for the main page
- UI for rule creation, viewing, and evaluation
- HTTP requests to interact with the backend API

## Deployment

For demonstration purposes, the Supabase credentials are hardcoded in the `main.py` file. In a production environment, these should be stored securely as environment variables or using a secret management system.

## Future Improvements

- Implement more complex rule parsing and AST construction
- Add user authentication and authorization
- Implement rule combination functionality
- Optimize rule evaluation performance
- Add more comprehensive error handling and validation


## Conclusion

This Rule Engine Application demonstrates a robust implementation of a flexible rule-based system. It showcases the integration of modern web technologies and provides a foundation for building more complex rule engines. The modular architecture allows for easy extensions and improvements, making it an excellent starting point for similar projects or further development.