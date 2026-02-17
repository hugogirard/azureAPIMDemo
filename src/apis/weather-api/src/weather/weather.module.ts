import { Module } from "@nestjs/common";
import { WeatherController } from './weather.controller';
import { ForecastService } from './forecast.service';

@Module({
    controllers: [WeatherController],
    providers: [ForecastService]
})
export class WeatherModule { }