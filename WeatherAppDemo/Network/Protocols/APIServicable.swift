//
//  APIServicable.swift


import Foundation
import Combine

struct Response<T> {
    let value: T // Parse Value
    let response: URLResponse? // URL Response
}

protocol APIServicable {
    func run<T: Decodable>(_ request: Requestable, _ decoder: JSONDecoder) -> AnyPublisher<Response<T>, NetworkError>
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkError>
}

extension APIServicable {
        
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkError> {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970

      return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
          .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}
