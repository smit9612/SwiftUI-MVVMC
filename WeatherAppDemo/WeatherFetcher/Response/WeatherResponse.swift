//
//  WeatherResponse.swift
//  WeatherAppDemo
//
//  Created by Smitesh Patel on 2021-12-17.
//

import Foundation

struct WeeklyForecastResponse: NetworkCodable {
    let list: [WeatherItem]
}

struct CurrentWeatherForecastResponse: NetworkCodable {
    let coord: Coord
    let main: MainClass
    
    enum CodingKeys: String, CodingKey {
        case coord
        case main = "main"
    }
}

// MARK: - CurrentWeatherForecastCitiesResponse

struct NearbyCitiesForeCastResponse: NetworkCodable {
    var message, cod: String?
    var count: Int?
    var list: [WeatherItem]
}

// MARK: - List

struct WeatherItem: Codable {
    var id: Int?
    var name: String?
    var pop: Double?
    var coord: Coord?
    var main: MainClass
    var dt: Int
    var wind: Wind?
    var sys: Sys?
    var rain: Rain?
    var snow: Snow?
    var clouds: Clouds?
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case id, coord, wind, sys, rain, snow, clouds, weather, dt, pop
        case main = "main"
    }
}

// MARK: - Clouds

struct Clouds: Codable {
    var all: Int?
}

// MARK: - Coord

struct Coord: Codable {
    var lat, lon: Double
}

// MARK: - MainClass

struct MainClass: Codable {
    var temperature, feelsLike, minTemperature, maxTemperature: Double
    var pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Rain

struct Rain: Codable {
    var the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Snow

struct Snow: Codable {
    var the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys

struct Sys: Codable {
    var pod: String?
}

// MARK: - Weather

struct Weather: Codable {
    var id: Int?
    var main: String?
    var weatherDescription: String
    var icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind

struct Wind: Codable {
    var speed: Double?
    var deg: Int?
}
