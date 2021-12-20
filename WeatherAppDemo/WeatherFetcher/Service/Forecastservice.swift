//
//  ForecastRequest.swift
//  WeatherAppDemo
//
//  Created by Smitesh Patel on 2021-12-17.
//

import Combine
import Foundation


struct PlatformNetwork {
    // Singleton
    static let scheme = "https"
    static let host = "https://api.openweathermap.org"
    static let path = "/data/2.5"
    static let key = "e81095d3df8b76067429fded5b5ca306"
    static var baseURL: String!
    static var apiService: APIServicable = API(publisher: APIDataTaskPublisherImpl(session: URLSession.shared))
}

protocol ForecastService {
    func weeklyWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<WeeklyForecastResponse, NetworkError>

    func currentWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<CurrentWeatherForecastResponse, NetworkError>

    func nearbyCurrentWeatherForecast(
        for lat: Double, lon: Double, count: Int
    ) -> AnyPublisher<NearbyCitiesForeCastResponse, NetworkError>
}



final class ForecastServiceImpl: ForecastService {

    func weeklyWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<WeeklyForecastResponse, NetworkError> {
        let weeklyForecastRequest = WeeklyForecastRequest(city: city)
        return PlatformNetwork.apiService.run(weeklyForecastRequest, JSONDecoder())
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func currentWeatherForecast(
        forCity city: String
    ) -> AnyPublisher<CurrentWeatherForecastResponse, NetworkError> {
        let currentWeatherRequest = CurrenForecastRequest(city: city)
        return PlatformNetwork.apiService.run(currentWeatherRequest, JSONDecoder())
            .map(\.value)
            .eraseToAnyPublisher()
    }

    func nearbyCurrentWeatherForecast(
        for lat: Double, lon: Double, count: Int
    ) -> AnyPublisher<NearbyCitiesForeCastResponse, NetworkError> {
        let nearbyWeatherRequest = NearbyForecastRequest(
            lat: lat,
            lon: lon,
            count: count
        )
        return PlatformNetwork.apiService.run(nearbyWeatherRequest, JSONDecoder())
            .map(\.value)
            .eraseToAnyPublisher()
    }

}
