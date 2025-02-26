//
//  Inject.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation

@propertyWrapper public struct Inject<T> {
    public var wrappedValue: T {
        return instance
    }

    private var instance: T
    public init() {
        instance = ResolverFactory.resolve(dependency: T.self)
    }
}
