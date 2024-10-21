import requests

url = "http://localhost:8000/rules/create"
headers = {"Content-Type": "application/json"}
data = {
    "name": "High salary rule",
    "ast": {
        "type": "operand",
        "value": "salary > 100000"
    }
}

response = requests.post(url, json=data, headers=headers)
print(response.status_code)
print(response.json())