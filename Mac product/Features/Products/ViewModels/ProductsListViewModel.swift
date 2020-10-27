//
//  ProductsListViewModel.swift
//  Mac product
//
//  Created by Mickael Belhassen on 26/10/2020.
//  Copyright © 2020 Mickael Belhassen. All rights reserved.
//

import Foundation


class ProductListViewModel: ObservableObject {

	private let productRepository: ProductRepositoryService

	@Published var products: [Product] = []


	init(productRepository: ProductRepositoryService) {
		self.productRepository = productRepository
	}

}


// MARK: - Networking

extension ProductListViewModel {

	func getProducts() {
		async {
			self.products = try! self.productRepository.getAll().await()
		}
	}

}