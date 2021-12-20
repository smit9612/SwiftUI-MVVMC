//
//  ForecastServiceTest.swift
//

import XCTest
import Combine

@testable import WeatherAppDemo

class ServiceTest: XCTestCase {
    var customPublisher: APIDataTaskPublisherImpl!

    override func setUp() {
        // now set up a configuration to use our mock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        // and create the URLSession from that
        let session = URLSession(configuration: config)
        customPublisher = APIDataTaskPublisherImpl(session: session)
    }

    override func tearDown() {
        PlatformNetwork.apiService = API(publisher: APIDataTaskPublisherImpl(session: URLSession.shared))
        URLProtocolMock.response = nil
        URLProtocolMock.error = nil
        URLProtocolMock.testURLs = [URL?: Data]()
    }
}

final class ForecastServiceTest: ServiceTest {
    
    func testCurrentWeatherForecasteAPISuccess() {
        // Auth Session API
        PlatformNetwork.apiService =
            MockAPIService(publisher: customPublisher, mockNetwork: .success)

        let forecastService = ForecastServiceImpl()
        let exp = expectation(description: "AuthAPI should be successful.")
        let authEvent = forecastService.currentWeatherForecast(forCity: "abcde").mapError { error -> NetworkError in
            error
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                XCTFail()
            }
        }, receiveValue: { _ in
            // either make
            XCTAssertTrue(Thread.isMainThread)
            exp.fulfill()
        })
        // wait for receivedAllValues to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(authEvent)
    }

    func testWeeklyWeatherForecastAPISuccess() {
        // Refresh Session API
        PlatformNetwork.apiService =
            MockAPIService(publisher: customPublisher, mockNetwork: .success)

        let forecastService = ForecastServiceImpl()
        let exp = expectation(description: "Refresh Session API should be successful.")

        let authEvent = forecastService.weeklyWeatherForecast(forCity: "abce")
            .mapError { error -> NetworkError in
            error
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure:
                XCTFail()
            }
        }, receiveValue: { _ in
            // either make
            XCTAssertTrue(Thread.isMainThread)
            exp.fulfill()

        })
        // wait for receivedAllValues to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(authEvent)
    }

    func testnearbyCurrentWeatherForecastSuccess() {
        // Refresh Session API
        PlatformNetwork.apiService =
        MockAPIService(publisher: customPublisher, mockNetwork: .success)

        let forecastService = ForecastServiceImpl()
        let exp = expectation(description: "Refresh Session API should be successful.")

        let authEvent = forecastService.nearbyCurrentWeatherForecast(for: 10, lon: 10, count: 10)
            .mapError { error -> NetworkError in
            error
        }.sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail()
            }
        }, receiveValue: { _ in
            // either make
            XCTAssertTrue(Thread.isMainThread)
            exp.fulfill()

        })
        // wait for receivedAllValues to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(authEvent)
    }
}
