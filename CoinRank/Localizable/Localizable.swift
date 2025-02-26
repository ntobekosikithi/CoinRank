//
//  Localizable.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation

struct Localizable {
    fileprivate let contents: String
    
    init(_ contents: String) {
        self.contents = contents
    }
}

extension String {
    
    static func localized(_ key: Localizable) -> String {
        return key.contents
    }
}
