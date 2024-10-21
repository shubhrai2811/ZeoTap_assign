import requests

url = "http://localhost:8000/rules/evaluate"
headers = {"Content-Type": "application/json"}
rule_id = 10  # Make sure this ID exists in your database

data = {
    "age": 30,
    "department": "Engineering",
    "salary": 110000,
    "experience": 5
}

response = requests.post(f"{url}?rule_id={rule_id}", json=data, headers=headers)

print("Status Code:", response.status_code)
print("Response Text:", response.text)

try:
    print("Response JSON:", response.json())
except requests.exceptions.JSONDecodeError:
    print("Could not decode JSON response")