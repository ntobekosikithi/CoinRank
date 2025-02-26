# CoinRank

## Overview

This iOS application fetches and displays cryptocurrency data from the CoinRanking API. The app features:
- A paginated list of the top 100 coins (20 per page)
- Filtering by highest price and best 24-hour performance
- A favorite functionality with swipe-to-favorite/unfavorite
- A detailed view with a performance chart and additional statistics

## Requirements

### Features
- Xcode 15.4+
- iOS 17.5+
- Swift 5+
- Swift Package Manager (SPM) for dependency management

## Dependencies
This project uses the following dependencies via Swift Package Manager (SPM):
- `Alamofire` for networking
- `Swinject` for dependency injection

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ntobekosikithi/CoinRank.git
   cd CoinRank

2. Open the workspace in Xcode:
   ```bash
    open CoinRank.xcodeproj    

Install dependencies:
- Xcode should automatically resolve and download dependencies when you open the project
- If not, go to `File → Packages → Resolve Package Versions`

4. Build and run the project on a simulator or physical device.


## Assumptions & Decisions
- Pagination loads 20 items per page automatically as the user scrolls.
- The app caches favorite coins locally using UserDefaults for simplicity (could be upgraded to CoreData in production).
- UIKit is used for main views like UITableView, while SwiftUI is used for modular components like coin cards.
- Network requests are managed using Alamofire.

## Challenges & Solutions
### 1. Handling API Pagination Efficiently
- **Challenge:** Ensuring data loads incrementally without redundant API calls.
- **Solution:** Implemented `scrollViewDidScroll` to fetch new pages only when reaching the bottom.

### 2. UI Consistency Between UIKit & SwiftUI
- **Challenge:** Combining UIKit (UITableView) and SwiftUI components.
- **Solution:** Embedded SwiftUI views inside UIHostingController.

### 3. Optimizing Performance for Large Data
- **Challenge:** Displaying and filtering 100 items efficiently.
- **Solution:** Caching images offline for smooth UI updates and scrolling.


## Future Enhancements
- Implement CoreData for better persistence of favorites
- Add search functionality for specific cryptocurrencies

## Future Enhancements
- **Data Caching**: Implement caching to improve performance and offline capabilities.
- **Dark Mode**: Enhance UI for dark mode compatibility.
- **Analytics Integration**: Track user interactions for insights and improvements.
- **Advanced Error Handling**: Categorize and handle different error types with better user feedback.
