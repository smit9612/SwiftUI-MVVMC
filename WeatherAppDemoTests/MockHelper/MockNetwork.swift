//
//  MockAPIService.swift
//  ComponentTests
//
//  Created by smitesh patel on 2020-08-20.
//  Copyright © 2020 Swift. All rights reserved.
//

import Combine
import Foundation

@testable import WeatherAppDemo

enum MockNetwork {
    case success
    case noData
    case invalidJSON
    case apiError

    case nonJSON
    case downloadError
    case invalidHTTPResponse
    case customResponse(responseFileName: String, statusCode: Int)

    var statusCode: Int {
        switch self {
        case .success, .noData, .invalidJSON, .nonJSON, .invalidHTTPResponse:
            return 200
        case .apiError:
            return 0
        case .downloadError:
            return 503
        case .customResponse(_, let statusCode):
            return statusCode
        }
    }

    static func == (lhs: MockNetwork, rhs: MockNetwork) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.noData, .noData):
            return true
        case (.invalidJSON, .invalidJSON):
            return true
        case (.apiError, .apiError):
            return true
        case (.invalidHTTPResponse, .invalidHTTPResponse):
            return true
        default:
            return false
        }
    }

    static func != (lhs: MockNetwork, rhs: MockNetwork) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return false
        case (.noData, .noData):
            return false
        case (.invalidJSON, .invalidJSON):
            return false
        case (.apiError, .apiError):
            return false
        case (.downloadError, .downloadError):
            return false
        case (.invalidHTTPResponse, .invalidHTTPResponse):
            return false
        case (.customResponse(let lhsFileName, let lhsStatusCode), .customResponse(let rhsFileName, let rhsStatusCode)):
            return lhsFileName != rhsFileName || lhsStatusCode != rhsStatusCode
        default:
            return true
        }
    }

    func httpResponse(for url: URL) -> HTTPURLResponse? {
        switch self {
        case .apiError:
            return nil
        default:
            return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: responseHeaderField)
        }
    }

    func resultData(fromURL url: URL, file _: String? = nil) -> Data? {
        switch self {
        case .success:
            let data = contentsOfFile(fromURL: url)
            return data
        default:
            return nil
        }
    }

    private var responseHeaderField: [String: String]? {
        ["Content-Type": "application/json"]
    }

    private func contentsOfFile(fromURL url: URL, file: String? = nil) -> Data? {
        let file = file ?? url.lastPathComponent
        guard
            let testBundle = getTestBundle(),
            let url = testBundle.url(forResource: file, withExtension: "json")
        else {
            assert(false, "Unable to find \(file) in test bundle")
        }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }
    
    func getTestBundle() -> Bundle? {
        return Bundle.allBundles.filter {
            if let resourcePath = $0.resourcePath,
               let url = URL(string: resourcePath) {
                return url.lastPathComponent == "WeatherAppDemoTests.xctest"
            }
            
            return false
        }.first
    }
}

final class MockAPIService: APIServicable {
    private var mockNetwork: MockNetwork
    var mockPublisher: APIDataTaskPublisherImpl!
    init(publisher: APIDataTaskPublisherImpl, mockNetwork: MockNetwork) {
        self.mockNetwork = mockNetwork
        mockPublisher = publisher
    }

    func run<T: Decodable>(_ request: Requestable, _: JSONDecoder) -> AnyPublisher<Response<T>, NetworkError> {
        // Set test URL and data content here
        if mockNetwork == .success {
            URLProtocolMock.response = mockNetwork.httpResponse(for: request.urlRequest.url!)
            URLProtocolMock.testURLs = [request.urlRequest.url: Data(mockNetwork.resultData(fromURL: request.urlRequest.url!)!)]
        }
        return mockPublisher.dataTaskPublisher(for: request.urlRequest)
            .tryMap { result -> Response<T> in

                // handle various Error scenarios
                guard let response = result.response as? HTTPURLResponse else {
                    throw NetworkError.restAPIError(data: nil)
                }

                guard response.isSuccessful else {
                    throw NetworkError.restAPIError(data: result.data)
                }
                let value = try result.data.decoded() as T
                return Response(value: value, response: response)
            }.mapError { error in
                if let error = error as? NetworkError {
                    return error
                } else {
                    return .networkError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
