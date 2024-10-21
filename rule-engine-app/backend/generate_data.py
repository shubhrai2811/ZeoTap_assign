import json
import random

def generate_user_data(num_users=100):
    departments = ["Sales", "Marketing", "Engineering", "HR"]
    users = []

    for _ in range(num_users):
        user = {
            "age": random.randint(18, 60),
            "department": random.choice(departments),
            "salary": random.randint(20000, 150000),
            "experience": random.randint(0, 40)
        }
        users.append(user)

    return users

if __name__ == "__main__":
    users = generate_user_data()
    with open("sample_users.json", "w") as f:
        json.dump(users, f, indent=2)
    print(f"Generated {len(users)} sample users in sample_users.json")