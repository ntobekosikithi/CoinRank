//
//  RootContentView.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import SwiftUI
import UIKit

func configureTabAndNavBarAppearance() {

    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.backgroundColor = .white

    let normalAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.gray,
        .font: UIFont(name: "OpenSans-Regular", size: 10) ??
              UIFont.systemFont(ofSize: 10, weight: .semibold)
    ]

    let selectedAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont(name: "OpenSans-Medium", size: 10) ??
              UIFont.systemFont(ofSize: 10, weight: .semibold)
    ]
    
    tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .gray
    tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
    tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .black
    tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
    
    UITabBar.appearance().standardAppearance = tabBarAppearance
    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    
    
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.configureWithOpaqueBackground()
    navBarAppearance.backgroundColor = .white
    navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]

    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = navBarAppearance
    navigationBar.scrollEdgeAppearance = navBarAppearance
    navigationBar.tintColor = .black
}

struct UINavigationControllerRepresentable<RootViewController: UIViewController>: UIViewControllerRepresentable {
    let rootViewController: RootViewController

    func makeUIViewController(context: Context) -> UINavigationController {
        UINavigationController(rootViewController: rootViewController)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

struct CoinListViewTab: View {
    var body: some View {
        UINavigationControllerRepresentable(rootViewController: CoinListViewController())
    }
}

struct FavoritesViewTab: View {
    var body: some View {
        UINavigationControllerRepresentable(rootViewController: FavoritesViewController())
    }
}

struct RootContentView: View {
    init() {
        configureTabAndNavBarAppearance()
    }
    var body: some View {
        TabView {
            let coinListTabTitle :String = .localized(.coinListTabTitle)
            let favoriteTabTitle :String = .localized(.favoriteTabTitle)
            CoinListViewTab()
                .tabItem {
                    Label(coinListTabTitle, systemImage: "list.dash")
                }
            FavoritesViewTab()
                .tabItem {
                    Label(favoriteTabTitle, systemImage: "suit.heart")
                }
        }
    }
}

#Preview {
    RootContentView()
}
