//
//  NetworkCodable.swift
//  WeatherAppDemo
//
//  Created by Smitesh Patel on 2021-12-18.
//

import Foundation
protocol NetworkCodable: Codable {
    /// Converts data to a PlatformNetworkCodable DataModel object
    ///
    /// - Parameter data: A JSON decodable data
    /// - Returns: An object conforming PlatformNetworkCodable
    static func from<T>(data: Data) -> T? where T: Codable

    /// Converts data to an array of PlatformNetworkCodable DataModel object
    ///
    /// - Parameter data: A JSON decodable data
    /// - Returns: An array of an object conforming PlatformNetworkCodable
    static func arrayFrom<T>(data: Data) -> [T]? where T: Codable

    /// A Data value, which is encoded from a PlatformNetworkCodable DataModel
    var data: Data? { get }
}

extension NetworkCodable {
    static func from<T>(data: Data) -> T? where T: Codable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        guard let decodedObj = try? data.decoded(as: T.self, using: jsonDecoder) as T else {
            print("Unable to decode \(T.self).")
            return nil
        }
        return decodedObj
    }

    static func arrayFrom<T>(data: Data) -> [T]? where T: Codable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedObj = try? data.decoded() as [T] else {
            print("Unable to decode array \(T.self).")
            return nil
        }

        return decodedObj
    }

    /// A Dictionary value having a key as String type, which is converted from an encoded data type of a PlatformNetworkCodable model
    var dictionary: [String: Any] {
        guard let data = data else { return [:] }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return [:] }
        guard let dic = jsonObject as? [String: Any] else { return [:] }
        return dic
    }

    var data: Data? {
        let camelCaseEncoder = JSONEncoder()
        camelCaseEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let encodedData = try? JSONEncoder().encode(self) else {
            print("Unable to encode \(self).")
            return nil
        }

        return encodedData
    }
}
