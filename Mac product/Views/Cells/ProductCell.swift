//
//  ProductCell.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import SwiftUI


struct ProductCell: View {

    let product: Product

    var body: some View {
        Text(product.generation)
    }

}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: Product(generation: "", id: "", models: []))
    }
}