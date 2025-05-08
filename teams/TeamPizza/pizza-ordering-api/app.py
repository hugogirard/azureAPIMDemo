from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from models import available_pizzas, PizzaOrder
from typing import List

app = FastAPI(title="Contoso Yummy Pizza",
              version="1.0",
              description="An API to order the best pizza in Town.")

@app.get("/",include_in_schema=False)
async def root():
    return RedirectResponse(url="/docs")

@app.get("/pizzas", response_model=List[dict])
async def get_pizzas():
    """
    Get the list of all available pizzas with toppings, sizes, and prices.
    """
    return available_pizzas


@app.post("/order")
async def order_pizza(order: PizzaOrder):
    """
    Place an order for a pizza.
    """
    # Find the pizza by ID
    pizza = next((p for p in available_pizzas if p["id"] == order.pizza_id), None)
    if not pizza:
        raise HTTPException(status_code=404, detail="Pizza not found")

    # Check if the size is valid
    if order.size not in pizza["sizes"]:
        raise HTTPException(status_code=400, detail="Invalid size selected")

    # Calculate the total price
    price_per_pizza = pizza["sizes"][order.size]
    total_price = price_per_pizza * order.quantity

    return {
        "message": "Order placed successfully!",
        "pizza": pizza["name"],
        "size": order.size,
        "quantity": order.quantity,
        "total_price": round(total_price, 2)
    }