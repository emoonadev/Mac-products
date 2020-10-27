//
//  ProductRepository.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation

protocol ProductRepositoryService {
    func getAll() -> Future<[Product]>
}

class ProductRepository: ProductRepositoryService {

    let apiClient: APIClientService

    init(apiClient: APIClientService) {
        self.apiClient = apiClient
    }

}


// MARK: - CRUD

extension ProductRepository {

    func getAll() -> Future<[Product]> {
        self.apiClient.perform(.getProducts)
    }

}