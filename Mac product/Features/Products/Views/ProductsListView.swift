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
        Text("Hello, World!")
    }
	
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
    }
}
