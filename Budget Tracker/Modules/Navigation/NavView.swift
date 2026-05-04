//
//  NavView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct NavView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "sterlingsign.arrow.circlepath")
                }
            
            SubscriptionsView()
                .tabItem {
                    Label("Subscriptions", systemImage: "square.grid.2x2.fill")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "folder")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
        }
        .tint(.cyan)
    }
    
    
}

#Preview {
    NavView()
}
