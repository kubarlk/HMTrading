//
//  MainView.swift
//  HMTrading
//
//  Created by Kirill Kubarskiy on 17.05.23.
//

import SwiftUI

struct MainView: View {
  init() {
    // Set the background color for TabBar
    UITabBar.appearance().backgroundColor = UIColor(hex: "#2E3241")
    // Create TabBarAppearance and TabBarItemAppearance
    let tabBarAppearance = UITabBarAppearance()
    let tabBarItemAppearance = UITabBarItemAppearance()
    // Configure the colors for selected and unselected tab bar items
    tabBarItemAppearance.selected.iconColor = UIColor(hex: "#35B972")
    tabBarItemAppearance.normal.iconColor = UIColor(hex: "#787D8F")
    // Configure the colors for selected and unselected tab bar item titles
    tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(hex: "#35B972") as Any]
    tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(hex: "#787D8F") as Any]
    // Assign TabBarItemAppearance to TabBarAppearance
    tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
    // Apply the appearances to the TabBar
    UITabBar.appearance().standardAppearance = tabBarAppearance
  }
  @State var selectedTab = 1
  var body: some View {

    TabView(selection: $selectedTab) {
      TradeView()
        .tabItem {
          Image(systemName: "chart.bar.fill")
          Text("Trade")
        }
        .tag(0)

      TopView()
        .tabItem {
          Image(systemName: "star.fill")
          Text("Top")
        }
        .tag(1)
    }
  }
}





struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
