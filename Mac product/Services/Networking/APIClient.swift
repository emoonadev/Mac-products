//
//  APIClient.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation
import SwiftCoroutine

protocol APIClientService {

}

class APIClient: APIClientService {

    let networking: NetworkingService = Networking()

}


// MARK: -

extension APIClient {

    func perform<T: Codable>(_ route: APIConstants.Route) -> CoFuture<T> {
        return CoFuture { promise in
            networking.request(url: route.request.url, method: route.request.method) { (result: Result<T, Error>) in
                switch result {
                    case .success(let obj):
                        promise(.success(obj))
                    case .failure(let error):
                        promise(.failure(error))
                }
            }
        }
    }

}