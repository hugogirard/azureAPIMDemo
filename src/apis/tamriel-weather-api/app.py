from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from data.weather_data import weather_data
from data.region import Region

app = FastAPI(title="Tamriel Weather Forecast",
              version="1.0",
              description="An API to get weather details for regions in Tamriel.")

@app.get("/",include_in_schema=False)
async def root():
    return RedirectResponse(url="/docs")

@app.get("/weather/{region}", tags=["GA"])
async def get_weather(region: Region):
    if region.value not in weather_data:
        raise HTTPException(status_code=404, detail="Region not found")
    return {
        "region": region.value,
        "temperature_celsius": weather_data[region.value]["temperature"],
        "description": weather_data[region.value]["description"],
    }