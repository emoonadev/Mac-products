//
//  APIConstants.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation

class APIConstants {

    static let baseURL = URL(string: "https://raw.githubusercontent.com/pbakondy/ios-device-list/master/")!

    struct Request {
        var url: URL
        var headers: [String: String]?
        var body: [String: Any]?
        var method: HTTPMethod = .post
    }

    enum Route {
        case getProducts

        var request: Request {
            var request = Request(url: baseURL, headers: ["Content-Type": "application/json"], body: [:])

            switch self {
                case .getProducts:
                    request.url = request.url.appendingPathComponent("iphone.json")
                    request.method = .get
            }

            return request
        }
    }

}

