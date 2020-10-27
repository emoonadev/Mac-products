//
//  DependenciesSetup.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation

extension DependencyFactory {

    override func registerDependencies() {
        registerServices()
        registerRepositories()
        registerViewModels()
    }

    private func registerServices() {
        register(APIClientService.self, instanceType: .single) { _ in APIClient() }
    }

    private func registerRepositories() {
    }

    private func registerViewModels() {
        register { _ in ProductListViewModel() }
    }

}