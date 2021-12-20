//
//  APIService.swift


import Combine
import Foundation
// Protoco to provide dataTaskPublisher
@available(OSX 10.15, iOS 13.0, *)
protocol APIDataTaskPublisher {
	func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

@available(OSX 10.15, iOS 13.0, *)
class APIDataTaskPublisherImpl: APIDataTaskPublisher {
	func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
		session.dataTaskPublisher(for: request)
	}

	func dataTask(for request: URLRequest) -> URLSessionDataTask {
		session.dataTask(with: request)
	}

	var session: URLSession

	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
}

protocol APIServiceProvider {
	var apiService: APIServicable { get }
}

@available(OSX 10.15, iOS 13.0, *)
struct API: APIServicable {
	private var logger: NetworkLogger!
	var publisher: APIDataTaskPublisher!

	init(publisher: APIDataTaskPublisher) {
		self.publisher = publisher
		logger = NetworkLogger(logFileName: "com.api.log")
	}

	func run<T: Decodable>(_ request: Requestable, _: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, NetworkError> {
		logger.log(request: request.urlRequest)
		return publisher.dataTaskPublisher(for: request.urlRequest)
			.tryMap { result -> Response<T> in
				// Logging the response data
				self.logger.log(response: result.response as? HTTPURLResponse, data: result.data)
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
				self.logger.logError(error: error)
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

// MARK: - Internals

extension HTTPURLResponse {
	var isSuccessful: Bool {
		200 ... 299 ~= statusCode
	}
}
