//
//  ContentView.swift
//  Mac product
//
//  Created by Mickael Belhassen on 26/10/2020.
//  Copyright © 2020 Mickael Belhassen. All rights reserved.
//

import SwiftUI

struct ProductsListView: View {

    @EnvironmentObservedResolve var viewModel: ProductListViewModel


    var body: some View {
        List(viewModel.products) { ProductCell(product: $0) }
                .onAppear {
                    self.viewModel.getProducts()
                }
    }

}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
    }
}
