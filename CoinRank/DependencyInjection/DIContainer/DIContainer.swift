//
//  DIContainer.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation
import Swinject

protocol Register {
    func register<T>(_ dependency: T.Type,
                     implementation: @escaping () -> T,
                     objectScope: ObjectScope)
}

protocol Resolve {
    func resolve<T>(_ dependency: T.Type) -> T
    func reset()
}

class DIContainer {
    let container: Container = Container()
    private init() {}
    public static let instance = DIContainer()
}

extension DIContainer: Register {
    
    func register<T>(_ dependency: T.Type,
                     implementation: @escaping () -> T,
                     objectScope: ObjectScope = .graph) {
        container.register(dependency, factory: { _ in
            return implementation()
        }).inObjectScope(objectScope)
    }
}

extension DIContainer: Resolve {
    
    func resolve<T>(_ dependency: T.Type) -> T {
        guard let implementation = container.resolve(dependency) else {
            fatalError("Sorry could not resolve your dependency. Make sure that this dependency is registered.")
        }
        return implementation
    }
    
    func reset() {
        container.removeAll()
    }
}
