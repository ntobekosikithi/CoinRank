//
//  FavoritesViewModelTests.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
import XCTest
@testable import CoinRank

class FavoritesViewModelTests: XCTestCase {
    private var container: DIContainer = DIContainer.instance
    private var mockFavoritesManager: MockFavoritesManager!
    private var mockView: MockCoinListView!
    private var serviceUnderTest: FavoritesViewModel!
    
    override func setUp() {
        super.setUp()
        container = DIContainer.instance
        mockFavoritesManager = MockFavoritesManager()
        mockView = MockCoinListView()
        container.register(FavoritesManager.self) { self.mockFavoritesManager }
        
        serviceUnderTest = FavoritesViewModel(view: mockView)
    }
    
    override func tearDown() {
        serviceUnderTest = nil
        mockView = nil
        mockFavoritesManager = nil
        container.reset()
        super.tearDown()
    }
    
    func testLoadFavorites_Success(){
        // Arrange
        let coin1 = MockCoinListRepository.createMockCoin(uuid: "3", rank: 1)
        let coin2 = MockCoinListRepository.createMockCoin(uuid: "5", rank: 9)
        let coin3 = MockCoinListRepository.createMockCoin(uuid: "2", rank: 34)
        mockFavoritesManager.saveFavorite(coin1)
        mockFavoritesManager.saveFavorite(coin2)
        mockFavoritesManager.saveFavorite(coin3)
        
        // Act
        serviceUnderTest.loadFavorites()
        
        // Assert
        XCTAssertEqual(serviceUnderTest.favoriteCoins.count, 3)
        XCTAssertEqual(mockView.showLoadingIndicatorCallCount, 1)
        XCTAssertEqual(mockView.hideLoadingIndicatorCallCount, 1)
        XCTAssertEqual(mockView.refreshTableViewCallCount, 1)
    }
}
