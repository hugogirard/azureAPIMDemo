import { BadRequestException, Body, Controller, Get, NotFoundException, Param, Post } from '@nestjs/common';
import { ForecastService } from './forecast.service';
import { ApiBody, ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger'
import { City } from './city';
import { Forecast } from './forecast';

@Controller('api/forecast')
export class WeatherController {
    constructor(private forecastService: ForecastService) { }

    @Get('/all')
    @ApiOperation({
        summary: 'Retrieve forecast for all cities',
        description: 'Return the forecast for all cities'
    })
    @ApiResponse({
        status: 200,
        description: 'Forecast of all cities',
        type: Array<Forecast>
    })
    getForecastAllCities(): Array<Forecast> {
        return this.forecastService.getForecastAllCities();
    }

    @Get('/:city')
    @ApiOperation({
        summary: 'Retrieve forecast of a city by city name',
        description: 'Return the forecast of a specific city'
    })
    @ApiParam({
        name: 'city',
        description: 'The name of the city',
        enum: City
    })
    @ApiResponse({
        status: 200,
        description: 'Forecast for the specific city',
        type: Forecast
    })
    @ApiResponse({
        status: 404,
        description: 'City with the specific name cannot be found'
    })
    getForecastByCity(@Param('city') city: City): Forecast | undefined {
        const forecast = this.forecastService.getForecast(city);

        if (forecast === undefined) {
            throw new NotFoundException(`Forecast for city ${city} not found`);
        }

        return forecast;
    }
}