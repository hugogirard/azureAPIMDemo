from pydantic import BaseModel

class PizzaOrder(BaseModel):
    pizza_id: int
    size: str
    quantity: int