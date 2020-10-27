//
//  Networking.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol NetworkingService {
    func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]?, queryItems: [URLQueryItem]?, body: [String: Any]?, completion: @escaping (Result<T, Error>) -> ())
}

extension NetworkingService {
    func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]? = nil, queryItems: [URLQueryItem]? = nil, body: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> ()) {
        request(url: url, method: method, headers: headers, queryItems: queryItems, body: body, completion: completion)
    }
}


class Networking: NetworkingService {

    private let urlSession = URLSession.shared
    var handleCustomErrors: ((_ statusCode: Int, _ message: String) -> Error)?


    func request<T: Decodable>(url: URL, method: HTTPMethod, headers: [String: String]? = nil, queryItems: [URLQueryItem]? = nil, body: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(CustomError(title: "Invalid endpoint", description: "Invalid endpoint", code: -1)))
            return
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            completion(.failure(CustomError(title: "Invalid endpoint", description: "Invalid endpoint", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print(error.localizedDescription)
            }
        }

        urlSession.dataTask(with: request) { result in
            switch result {
                case .success(let (response, data)):
                    do {
                        let values = try JSONDecoder().decode(T.self, from: data)
                        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                            completion(.failure(CustomError(title: "Error", description: "Error", code: (response as? HTTPURLResponse)?.statusCode ?? -5)))
                            return
                        }

                        completion(.success(values))
                    } catch {
                        completion(.failure(CustomError(title: "Error when decoding json", description: "Error when decoding json", code: -3)))
                    }

                case .failure(let error):
                    completion(.failure(CustomError(title: error.localizedDescription, description: error.localizedDescription, code: -4)))
            }
        }.resume()
    }

}


// MARK: - Extension

extension URLSession {

    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }

            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }

            result(.success((response, data)))
        }
    }

}
