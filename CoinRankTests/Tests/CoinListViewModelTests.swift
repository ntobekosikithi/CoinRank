//
//  CoinListViewModelTests.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
import XCTest
@testable import CoinRank

class CoinListViewModelTests: XCTestCase {
    private var container: DIContainer = DIContainer.instance
    private var mockRepository: MockCoinListRepository!
    private var mockFavoritesManager: MockFavoritesManager!
    private var mockView: MockCoinListView!
    private var serviceUnderTest: CoinListViewModel!
    
    override func setUp() {
        super.setUp()
        container = DIContainer.instance
        mockRepository = MockCoinListRepository()
        mockFavoritesManager = MockFavoritesManager()
        mockView = MockCoinListView()
        
        container.register(CoinListRepository.self) { self.mockRepository }
        container.register(FavoritesManager.self) { self.mockFavoritesManager }
        
        serviceUnderTest = CoinListViewModel(view: mockView)
    }
    
    override func tearDown() {
        serviceUnderTest = nil
        mockView = nil
        mockRepository = nil
        mockFavoritesManager = nil
        container.reset()
        super.tearDown()
    }
    
    func testLoadCoins_Success() async {
        // Arrange
        let mockResponse = MockCoinListRepository.createMockCoinListResponse()
        mockRepository.mockResponse = mockResponse
        
        // Act
        await serviceUnderTest.fetchCoinList()
        
        // Assert
        XCTAssertEqual(serviceUnderTest.coins.count, mockResponse.data.coins.count)
        XCTAssertEqual(mockRepository.fetchCoinsCallCount, 1)
        XCTAssertEqual(serviceUnderTest.currentPage, 1)
        XCTAssertEqual(mockView.showLoadingIndicatorCallCount, 1)
        XCTAssertEqual(mockView.hideLoadingIndicatorCallCount, 1)
        XCTAssertEqual(mockView.refreshTableViewCallCount, 1)
    }

    func testFetchCoins_Failure() async {
        // Arrange
        let mockError = NSError(domain: "TestError", code: -1, userInfo: nil)
        mockRepository.mockError = mockError
        
        // Act
        await serviceUnderTest.fetchCoinList()
        
        // Assert
        XCTAssertEqual(mockRepository.fetchCoinsCallCount, 1)
        XCTAssertEqual(mockView.showLoadingIndicatorCallCount, 1)
        XCTAssertEqual(mockView.hideLoadingIndicatorCallCount, 1)
        XCTAssertEqual(mockView.displayErrorCallCount, 1)
        XCTAssertEqual(mockView.lastErrorMessage, mockError.localizedDescription)
    }
    
    func testSortByPrice() {
        // Arrange
        serviceUnderTest.coins = [
            MockCoinListRepository.createMockCoin(uuid: "1", price: "30000"),
            MockCoinListRepository.createMockCoin(uuid: "2", price: "50000"),
            MockCoinListRepository.createMockCoin(uuid: "2", price: "80000"),
            MockCoinListRepository.createMockCoin(uuid: "3", price: "20000")
        ]
            
        // Act
        serviceUnderTest.sortByPrice()
            
        // Assert
        XCTAssertEqual(serviceUnderTest.coins.first?.price, "80000")
        XCTAssertEqual(serviceUnderTest.coins.last?.price, "20000")
    }
    

    func testSortByPerformance() {
        // Arrange
        serviceUnderTest.coins = [
            MockCoinListRepository.createMockCoin(uuid: "1", price: "30000", change: "1.2"),
            MockCoinListRepository.createMockCoin(uuid: "2", price: "50000", change: "2.5"),
            MockCoinListRepository.createMockCoin(uuid: "3", price: "20000", change: "-1.0"),
            MockCoinListRepository.createMockCoin(uuid: "1", price: "30000", change: "1.6")
        ]
        
        // Act
        serviceUnderTest.sortByPerformance()
        
        // Assert
        XCTAssertEqual(serviceUnderTest.coins.first?.change, "2.5")
        XCTAssertEqual(serviceUnderTest.coins.last?.change, "-1.0")
    }
    
    
    func testSortByRanking() {
        // Arrange
        serviceUnderTest.coins = [
            MockCoinListRepository.createMockCoin(uuid: "1", rank: 3),
            MockCoinListRepository.createMockCoin(uuid: "2", rank: 1),
            MockCoinListRepository.createMockCoin(uuid: "2", rank: 4),
            MockCoinListRepository.createMockCoin(uuid: "3", rank: 2)
        ]
        
        // Act
        serviceUnderTest.sortByRanking()
        
        // Assert
        XCTAssertEqual(serviceUnderTest.coins.first?.rank, 1)
        XCTAssertEqual(serviceUnderTest.coins.last?.rank, 4)
    }
    
    func testSaveFavorite() {
        // Arrange
        let coin = MockCoinListRepository.createMockCoin()
        
        // Act
        serviceUnderTest.saveFavorite(coin)
        
        // Assert
        XCTAssertTrue(mockFavoritesManager.isFavorite(coin))
    }
    
    func testRemoveFavorite() {
        // Arrange
        let coin = MockCoinListRepository.createMockCoin()
        serviceUnderTest.saveFavorite(coin)
        
        // Act
        serviceUnderTest.removeFavorite(coin)
        
        // Assert
        XCTAssertFalse(mockFavoritesManager.isFavorite(coin))
    }
}
