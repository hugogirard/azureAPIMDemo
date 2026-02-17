import { Injectable } from '@nestjs/common'
import { City } from './city'
import { Forecast } from './forecast'

@Injectable()
export class ForecastService {

    private forecast: Array<Forecast>;

    constructor() {
        this.forecast = [
            {
                city: City.Montreal,
                temperature: '15°C',
                description: 'Partly cloudy with a chance of rain'
            },
            {
                city: City.Quebec,
                temperature: '12°C',
                description: 'Cloudy with light showers'
            },
            {
                city: City.Toronto,
                temperature: '18°C',
                description: 'Sunny and clear'
            },
            {
                city: City.Vancouver,
                temperature: '16°C',
                description: 'Overcast with occasional drizzle'
            }
        ];
    }

    getForecast(city: City): Forecast | undefined {
        return this.forecast.find(c => c.city == city);
    }

    getForecastAllCities(): Array<Forecast> {
        return this.forecast;
    }
}