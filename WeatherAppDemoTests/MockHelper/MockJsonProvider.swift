//
//  MockJSONProvider.swift
//  
//
//  Created by Smitesh Patel on 2021-04-25.
//

import Foundation
@testable import WeatherAppDemo

enum MockDataType: String {
    case find = "mockfind"
    case forecast = "mockforecast"
    case weather = "mockWeather"
}
// MARK: - Platform Network Codable
@propertyWrapper struct MockedResponse<Value: NetworkCodable> {
    let type: MockDataType

    var wrappedValue: Value? {
        get { Value.from(data: MockJSONProvider.shared.data(forType: type)) }
    }
}

@propertyWrapper struct MockedCollectionResponse<Value: NetworkCodable> {
    let type: MockDataType

    var wrappedValue: [Value]? {
        get { Value.arrayFrom(data: MockJSONProvider.shared.data(forType: type)) }
    }
}

final class MockJSONProvider {

    static let shared: MockJSONProvider = MockJSONProvider()

    func data(forType mockDataType: MockDataType) -> Data {
        
        guard let url = Bundle(for: type(of: self)).url(forResource: mockDataType.rawValue, withExtension: "json") else {
            fatalError("JSON file \(mockDataType.rawValue).json not found")
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            fatalError("Unable to read JSON file \(mockDataType).json")
        }
    }
}
