//
//  APIError.swift


import Foundation

enum NetworkError: Error {
    case unknownError
    case networkError(Error)
    case parsing(description: String)
    case restAPIError(data: Data?)
}
