//
//  AuthRequestTests.swift
//  
//
//  Created by Smitesh Patel on 2021-04-25.
//

@testable import WeatherAppDemo
import XCTest

class NearbyForecastRequestTest: XCTestCase {

    func testNearbyForecastRequestHasGetMethod() {
        let authRequest = NearbyForecastRequest(lat: 0.0, lon: 0.0, count: 1)
        XCTAssertEqual(authRequest.httpMethod, .get)
    }
    
    func testCurrenForecastRequestHasPostMethod() {
        let authRequest = CurrenForecastRequest(city: "abc")
        XCTAssertEqual(authRequest.httpMethod, .post)
    }
    
    func testWeeklyForecastRequestHasPostMethod() {
        let authRequest = WeeklyForecastRequest(city: "abc")
        XCTAssertEqual(authRequest.httpMethod, .post)
    }
    
    func testNearbyForecastRequestQueryParamsHasLatLonCountKeys() {
        let authRequest = NearbyForecastRequest(lat: 0.0, lon: 0.0, count: 1)
        XCTAssertNotNil(authRequest.queryParams?.keys.filter { $0 == "lat" }.first)
        XCTAssertNotNil(authRequest.queryParams?.keys.filter { $0 == "lon" }.first)
        XCTAssertNotNil(authRequest.queryParams?.keys.filter { $0 == "cnt" }.first)
    }
    
    func testCurrenForecastRequestQueryParamsHasCityKey() {
        let authRequest = CurrenForecastRequest(city: "abc")
        XCTAssertNotNil(authRequest.queryParams?.keys.filter { $0 == "q" }.first)
    }
    
    func testWeeklyForecastRequestQueryParamsHasHasCityKey() {
        let authRequest = WeeklyForecastRequest(city: "abc")
        XCTAssertNotNil(authRequest.queryParams?.keys.filter { $0 == "q" }.first)
    }
}
