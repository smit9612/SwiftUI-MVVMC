//
//  CityListViewUITests.swift
//  WeatherAppDemoUITests
//
//  Created by smiteshP on 20/12/21.
//

import XCTest
//import ViewInspector
//@testable import WeatherAppDemo

class CityListViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   /* func testSearchButton() throws {
        let sut = CityListViewUI(viewModel: CityListViewModel(coordinator: CityListCoordinator()))
        let text = try sut.inspect().vStack().view(PrimaryButton.self, 1).text().string()
        XCTAssertEqual(text, "Search")
    }*/

}

//extension PrimaryButton: Inspectable {}
