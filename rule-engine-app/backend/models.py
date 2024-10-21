from pydantic import BaseModel
from typing import Optional, List

class Node(BaseModel):
    type: str
    value: Optional[str] = None
    left: Optional['Node'] = None
    right: Optional['Node'] = None

class Rule(BaseModel):
    id: Optional[int] = None
    name: str
    ast: Node

class UserData(BaseModel):
    age: int
    department: str
    salary: int
    experience: int