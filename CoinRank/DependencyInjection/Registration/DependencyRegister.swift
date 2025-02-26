//
//  DependencyRegister.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation
func registerAllDependencies() {
    let container = DIContainer.instance
    container.register(CoinService.self) { CoinServiceImplementation() }
    container.register(CoinListRepository.self) { CoinListRepositoryImplementation() }
    container.register(CoinDetailsRepository.self) { CoinDetailsRepositoryImplementation() }
    container.register(FavoritesManager.self) { FavoritesManagerImplementation() }

}
