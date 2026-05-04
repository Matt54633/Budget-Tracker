//
//  CategoryTransactionList.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData

struct CategoryTransactionList: View {
    @Query private var categories: [Category]
    @Environment(\.modelContext) var context
    
    var categoriesWithTransactions: [Category] {
        categories.filter { !($0.transactions?.isEmpty ?? false) }
    }
    
    var body: some View {
        ScrollView {
            ForEach(categoriesWithTransactions, id: \.self) { category in
                Section(header: CategoryHeaderView(title: category.title)) {
                    ForEach(category.transactions ?? [], id: \.self) { transaction in
                        TransactionListItemView(transaction: transaction)
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .padding(.horizontal)
            .tint(.primary)
        }
    }
}

#Preview {
    CategoryTransactionList()
}
