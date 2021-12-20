//
//  CityViewModelTests.swift
//  WeatherAppDemoTests
//
//  Created by Smitesh Patel on 2021-12-20.
//
import XCTest
import Combine

@testable import WeatherAppDemo

import Foundation
final class CityViewModelTests: AppTests {
    func testWeeklyWeatherViweModel() {
        let cityListCoordinator = CityListCoordinator()
        let cityDetailsViewModel = CityDetailsViewModel(coordinator: cityListCoordinator, name: "Toronto")
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertEqual(cityDetailsViewModel.weeklyWeatherForecast.count, 6)
            XCTAssertNotNil(cityDetailsViewModel.cityDetailModel)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
