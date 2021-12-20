//
//  AuthSessionResponseTests.swift
//

@testable import WeatherAppDemo
import XCTest

final class WeeklyForecastResponseTest: XCTestCase {
    
    func testWeeklyForecastResponsee() {
        // Given an authResponse
        // When authResponse is successful
        let authResponse = WeeklyForecastResponse.mockWeeklyForecast
        XCTAssertNotNil(authResponse)
    }
    
    func testCurrentWeatherForecastResponse() {
        // Given an authResponse
        // When authResponse is successful
        let authResponse = CurrentWeatherForecastResponse.mockCurrentWeather
        XCTAssertNotNil(authResponse)
    }
    
    func testNearbyCitiesForeCastResponse() {
        // Given an authResponse
        // When authResponse is successful
        let authResponse = NearbyCitiesForeCastResponse.mockNearbyCities
        XCTAssertNotNil(authResponse)
    }
}
