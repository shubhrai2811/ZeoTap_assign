import requests

url = "http://localhost:8000/rules"
response = requests.get(url)

print("Status Code:", response.status_code)
print("Response:", response.json())
