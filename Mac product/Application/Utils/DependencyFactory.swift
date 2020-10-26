//
//  DependencyFactory.swift
//  Mac product
//
//  Created by Mickael Belhassen on 26/10/2020.
//  Copyright © 2020 Mickael Belhassen. All rights reserved.
//

import SwiftUI

protocol Resolver {
    func resolve<T>() -> T
}

struct DependencyInjector {

    enum InstanceType {
        case single, new
    }

    static var dependencies: Resolver = DependencyFactory()

}

class BaseContainer {
    @objc dynamic func registerDependencies() {}
}

class DependencyFactory: BaseContainer, Resolver {

    private var services = [String: () -> Any]()
    private var uniqueInstanceServices = [String: Any]()


    override init() {
        super.init()
        registerDependencies()
    }

}


// MARK: Resolver / Register

extension DependencyFactory {

    func resolve<T>() -> T {
        let serviceName = String(describing: T.self)

        guard let service = (services[serviceName]?() ?? uniqueInstanceServices[serviceName]) as? T else {
            fatalError("\(serviceName) not registered. Make sure that you are trying to resolve services already registered. The order of service registration is important")
        }

        return service
    }

    func register<T>(_ type: T.Type = T.self, instanceType: DependencyInjector.InstanceType = .new, apply: @escaping (DependencyFactory) -> T) {
        let serviceName = String(describing: T.self).components(separatedBy: ".")[0]

        guard !isExist(in: services, for: serviceName) || !isExist(in: uniqueInstanceServices, for: serviceName) else { fatalError("\(serviceName) already registered. Only one registration can be made per service") }

        if instanceType == .new {
            services[serviceName] = { apply(self) }
        } else {
            uniqueInstanceServices[serviceName] = apply(self)
        }
    }

    private func isExist(in services: [String: Any], for key: String) -> Bool {
        return services.first { $0.key == key } != nil
    }

    func autoResolveSingle<T, A>(_ initializer: (A) -> T) -> T { initializer(resolve()) }
    func autoResolve<T, A, B>(_ initializer: (A, B) -> T) -> T { initializer(resolve(), resolve()) }
    func autoResolve<T, A, B, C>(_ initializer: (A, B, C) -> T) -> T { initializer(resolve(), resolve(), resolve()) }
    func autoResolve<T, A, B, C, D>(_ initializer: (A, B, C, D) -> T) -> T { initializer(resolve(), resolve(), resolve(), resolve()) }
    func autoResolve<T, A, B, C, D, E>(_ initializer: (A, B, C, D, E) -> T) -> T { initializer(resolve(), resolve(), resolve(), resolve(), resolve()) }

}

@propertyWrapper
struct LazyResolve<T> {

    lazy var service: T = DependencyInjector.dependencies.resolve()

    var wrappedValue: T {
        mutating get {
            return service
        }
        set {
            service = newValue
        }
    }

}

@propertyWrapper
struct Resolve<T> {

    var service: T = DependencyInjector.dependencies.resolve()

    var wrappedValue: T {
        get {
            return service
        }
        set {
            service = newValue
        }
    }

}

@propertyWrapper
public struct EnvironmentObservedResolve<T: ObservableObject>: DynamicProperty {

    @ObservedObject private var _service: T

    public var wrappedValue: T {
        _service
    }

    public init() {
        self.__service = ObservedObject<T>(initialValue: DependencyInjector.dependencies.resolve())
    }

    public var projectedValue: ObservedObject<T>.Wrapper {
        return __service.projectedValue
    }

}
