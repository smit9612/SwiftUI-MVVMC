//
//  FactRequest.swift


import Foundation

protocol WeatherRequestable: Requestable {
    var openWeatherQueryParams: [String: String] { get }
}

extension WeatherRequestable {
    var baseURL: String {
        return PlatformNetwork.host
    }

    var openWeatherQueryParams: [String : String] {
        return ["mode" : "json",
                "units" : "metric",
                "appid": PlatformNetwork.key]
    }
}

struct NearbyForecastRequest: WeatherRequestable {

    let lat: Double
    let lon: Double
    let count: Int

    var urlPath: String {
        return "\(PlatformNetwork.path)/find"
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var queryParams: [String : Any]? {
        var foreCastQueryParams = openWeatherQueryParams
        foreCastQueryParams.updateValue("\(lat)", forKey: "lat")
        foreCastQueryParams.updateValue("\(lon)", forKey: "lon")
        foreCastQueryParams.updateValue("\(count)", forKey: "cnt")
        return foreCastQueryParams
    }

}

struct CurrenForecastRequest: WeatherRequestable {
    var city: String
    
    var urlPath: String {
        return "\(PlatformNetwork.path)/weather"
    }

    var queryParams: [String : Any]? {
        var foreCastQueryParams = openWeatherQueryParams
        foreCastQueryParams.updateValue(city, forKey: "q")
        return foreCastQueryParams
    }
}

struct WeeklyForecastRequest: WeatherRequestable {
    var city: String

    var urlPath: String {
        return "\(PlatformNetwork.path)/forecast"
    }

    var queryParams: [String : Any]? {
        var foreCastQueryParams = openWeatherQueryParams
        foreCastQueryParams.updateValue(city, forKey: "q")
        return foreCastQueryParams
    }
}

