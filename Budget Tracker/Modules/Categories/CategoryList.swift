//
//  CategoryList.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData

struct CategoryList: View {
    @Query private var categories: [Category]
    @Query private var transactions: [Transaction]
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) var context
    @State private var showAlert: Bool = false
    @State private var categoryToDelete: Category?
    
    var body: some View {
        VStack {
            List(categories.sorted(by: { $0.title < $1.title }), id: \.self) { category in
                CategoryListItemView(category: category)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .swipeActions {
                        if category.title != "Apple Pay" {
                            Button("Delete") {
                                categoryToDelete = category
                                showAlert = true
                            }
                            .tint(.red)
                            
                        }
                    }
            }
            .padding(.top, -20)
            .listRowSpacing(12)
            .tint(.primary)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text("All transactions and subscriptions for this category will also be deleted. Are you sure you want to continue?"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        if let category = categoryToDelete {
                            let transactionsToDelete = transactions.filter { $0.category == category }
                            for transaction in transactionsToDelete {
                                context.delete(transaction)
                            }
                            
                            let subscriptionsToDelete = subscriptions.filter { $0.category == category }
                            for subscription in subscriptionsToDelete {
                                context.delete(subscription)
                            }
                            
                            context.delete(category)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    CategoryList()
}
