//
//  Product.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation

typealias Products = [Product]

struct Product: Codable, Identifiable {
    let generation: String
    let id: String
    let models: [Model]

    enum CodingKeys: String, CodingKey {
        case generation = "Generation"
        case id = "Identifier"
        case models = "Models"
    }
}


// MARK: - Models

extension Product {

    struct Model: Codable {
        let color: String
        let storage: String
        let models: [String]

        enum CodingKeys: String, CodingKey {
            case color = "Color"
            case storage = "Storage"
            case models = "Model"
        }
    }

}
