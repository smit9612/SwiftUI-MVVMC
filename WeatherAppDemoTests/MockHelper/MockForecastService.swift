//
//  MockFetchService.swift
//  WeatherAppDemo
//
//  Created by Smitesh Patel on 2021-12-19.
//

import Foundation
import Combine
@testable import WeatherAppDemo

struct  EmptyModel: Codable {}

final class MockForecastServiceImpl: ForecastService  {

    func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, NetworkError> {
            return Just(WeeklyForecastResponse.mockWeeklyForecast!)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()

    }

    func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, NetworkError> {
        //if let mockCurrentWeather: CurrentWeatherForecastResponse = CurrentWeatherForecastResponse.mockCurrentWeather {
            return Just(CurrentWeatherForecastResponse.mockCurrentWeather!)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher() as! AnyPublisher<CurrentWeatherForecastResponse, NetworkError>
        //}
    }

    func nearbyCurrentWeatherForecast(for lat: Double, lon: Double, count: Int) -> AnyPublisher<NearbyCitiesForeCastResponse, NetworkError> {
        return Just(NearbyCitiesForeCastResponse.mockNearbyCities!)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher() as! AnyPublisher<NearbyCitiesForeCastResponse, NetworkError>
    }
}
