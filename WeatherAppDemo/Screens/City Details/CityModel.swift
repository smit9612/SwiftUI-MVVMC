//
//  CityModel.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import MapKit
import Foundation

struct CityModel {
    let name: String

    init(item: WeatherItem) {
        name = item.name ?? ""
    }
}

struct CityDetailModel {

    let temperature: String
    let feelsLike: String
    let minTemperature: String
    let maxTemperature: String
    let humidity: String
    var coordinate: CLLocationCoordinate2D

    init(currentWeatherForecast: CurrentWeatherForecastResponse) {
        let main = currentWeatherForecast.main
        temperature = String(format: "%.1f", main.temperature)
        maxTemperature = String(format: "%.1f", main.maxTemperature)
        minTemperature = String(format: "%.1f", main.minTemperature)
        humidity = String(format: "%.1f", main.humidity)
        feelsLike = String(format: "%.1f", main.feelsLike)
        coordinate = CLLocationCoordinate2D(
            latitude: currentWeatherForecast.coord.lat,
            longitude: currentWeatherForecast.coord.lon)
    }
}

struct DailyWeatherRowViewModel: Identifiable {
    
    enum WeatherIconDay: String {
        case clearSky = "01d"
        case fewClouds = "02d"
        case scatteredClouds = "03d"
        case brokenClouds = "04d"
        case showerRain = "09d"
        case rain = "10d"
        case thunderstorm = "11d"
        case snow = "13d"
        case mist = "50d"
        
        func getLottieFileName() -> String {
            switch self {
            case .clearSky:
                return "day-clear-sky"
            case .fewClouds:
                return "day-few-clouds"
            case .scatteredClouds:
                return "day-scattered-clouds"
            case .brokenClouds:
                return "day-broken-clouds"
            case .showerRain:
                return "day-shower-rains"
            case .rain:
                return "day-rain"
            case .thunderstorm:
                return "day-thunderstorm"
            case .snow:
                return "day-snow"
            case .mist:
                return "day-mist"
            }
        }
    }
    
    enum WeatherIconNight: String {
        case clearSky = "01n"
        case fewClouds = "02n"
        case scatteredClouds = "03n"
        case brokenClouds = "04n"
        case showerRain = "09n"
        case rain = "10n"
        case thunderstorm = "11n"
        case snow = "13n"
        case mist = "50n"
        
        func getLottieFileName() -> String {
            switch self {
            case .clearSky:
                return "night-clear-sky"
            case .fewClouds:
                return "night-few-clouds"
            case .scatteredClouds:
                return "night-scattered-clouds"
            case .brokenClouds:
                return "night-broken-clouds"
            case .showerRain:
                return "night-shower-rains"
            case .rain:
                return "night-rain"
            case .thunderstorm:
                return "night-thunderstorm"
            case .snow:
                return "night-snow"
            case .mist:
                return "night-mist"
            }
        }
    }

    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()

    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()

    private let item: WeatherItem

    var id: String {
        day + temperature + title
    }

    var day: String {
        dayFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval.init(item.dt)))
    }

    var month: String {
       monthFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval.init(item.dt)))
    }

    var temperature: String {
        String(format: "%.1f", item.main.temperature)
    }
    
    var windSpeed: String {
        if let wind = item.wind,
            let speed = wind.speed {
            return "\(speed)km/hr"
        }
        
        return "0 km/hr"
    }
    
    var humidity: String {
        "\(item.main.humidity) %"
    }
    
    var precipitation: String {
        (item.pop == nil) ? "0%" : "\(item.pop!)%"
    }

    var title: String {
        guard let title = item.weather.first?.main else { return "" }
        return title
    }

    var fullDescription: String {
        guard let description = item.weather.first?.weatherDescription else { return "" }
        return description
    }
    
    var weatherIconLottieFileName: String? {
        if let weather = item.weather.first,
           let icon = weather.icon {
            return icon.contains("d") ?
            WeatherIconDay(rawValue: icon)?.getLottieFileName() :
            WeatherIconNight(rawValue: icon)?.getLottieFileName()
        }
        
        return nil
    }

    init(item: WeatherItem) {
        self.item = item
    }

}

// Used to hash on just the day in order to produce a single view model for each
// day when there are multiple items per each day.
extension DailyWeatherRowViewModel: Hashable {
    static func == (lhs: DailyWeatherRowViewModel, rhs: DailyWeatherRowViewModel) -> Bool {
        lhs.day == rhs.day
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(day)
    }
}
