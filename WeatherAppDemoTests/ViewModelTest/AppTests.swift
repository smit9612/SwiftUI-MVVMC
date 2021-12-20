//
//  CityDetailModelTests.swift
//  WeatherAppDemoTests
//
//  Created by Smitesh Patel on 2021-12-19.
//

import Foundation
import XCTest
import Combine

@testable import WeatherAppDemo

class AppTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ManagerInjector.forecastService = MockForecastServiceImpl()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

func assertEmptyString(_ value: String, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(value, "", "Not an empty string")
}

func assertNotNilOptional(_ value: Any?, file: StaticString = #file, line: UInt = #line) {
    if value == nil {
        XCTFail("Provided value is nil")
    }
}

func assertNilOptional(_ value: Any?, file: StaticString = #file, line: UInt = #line) {
    if value != nil {
        XCTFail("Provided value is not nil")
    }
}


