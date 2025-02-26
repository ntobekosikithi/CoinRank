//
//  CoinRankApp.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerAllDependencies()
        return true
    }
}

@main
struct CoinRankApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootContentView()
        }
    }
}
