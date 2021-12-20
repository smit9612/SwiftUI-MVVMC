//
//  Requestable.swift


import Foundation

enum HTTPMethod: String {
    /// It requests a representation of the specified resource. Requests using GET should only retrieve data.
    case get = "GET"
    /// It sends data to the server. The type of the body of the request is indicated by the Content-Type header.
    case post = "POST"
    /// It requests the headers that are returned if the specified resource would be requested with an HTTP GET method.
    case head = "HEAD"
    /// It creates a new resource or replaces a representation of the target resource with the request payload.
    case put = "PUT"
    /// It deletes the specified resource.
    case delete = "DELETE"
    /// It starts two-way communications with the requested resource. It can be used to open a tunnel.
    case connect = "CONNECT"
    /// It is used to describe the communication options for the target resource. The client can specify a URL for the OPTIONS method, or an asterisk (*) to refer to the entire server.
    case options = "OPTIONS"
    /// It performs a message loop-back test along the path to the target resource, providing a useful debugging mechanism.
    case trace = "TRACE"
    /// It applies partial modifications to a resource.
    case patch = "PATCH"
}

// MARK: - Requestable
protocol Requestable {
    
    var baseURL: String { get }
    var urlPath: String { get }
    var httpMethod: HTTPMethod { get }
    var httpHeaders: [String: String]? { get }
    var httpBody: Data? { get }
    var queryParams: [String: Any]? { get }
    var urlRequest: URLRequest { get }
}

// MARK: - Internal Requestable
extension Requestable {
    
    // Can be set for each requestable
    var baseURL: String {
        return "www.google.ca"
    }

    var urlPath: String {
        return ""
    }

    var httpMethod: HTTPMethod {
        return .post
    }
    
    var httpHeaders: [String : String]? {
        return defaultHttpHeaders
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var queryParams: [String : Any]? {
        return nil
    }

    var urlRequest: URLRequest {
        return defaultURLRequest
    }

    var defaultURLRequest: URLRequest {
        let url = URL(string: baseURL)!.appendingPathComponent(urlPath)
        var req = URLRequest(url: url)
        req.httpMethod = httpMethod.rawValue
        req.allHTTPHeaderFields = httpHeaders
        req.httpBody = httpBody
        req.url = encode(url: req.url, queryParams: queryParams)
        return req
    }

    var defaultHttpHeaders: [String: String] {
        let headers = ["Content-Type":"application/json"]
        return headers
    }
    
    func encode(url: URL?, queryParams: [String: Any]?) -> URL? {
        guard let url = url else { return nil }
        guard let queryParams = queryParams else { return url }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !queryParams.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(queryParams)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            return urlComponents.url
        }
        
        return url
    }
    
}

// MARK: - Private Requestable
extension Requestable {
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((key.escape, value.boolValue ? "1".escape : "0".escape))
            } else {
                components.append((key.escape, "\(value)".escape))
            }
        } else if let bool = value as? Bool {
            components.append((key.escape, bool ? "1".escape : "0".escape))
        } else {
            components.append((key.escape, "\(value)".escape))
        }
        
        return components
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            if let value = parameters[key] {
                components += queryComponents(fromKey: key, value: value)
            }
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}

// MARK: - Fileprivate String
extension String {
    
    fileprivate var escape: String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
}

// MARK: - Fileprivate NSNumber
extension NSNumber {
    
    fileprivate var isBool: Bool {
        return CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}
