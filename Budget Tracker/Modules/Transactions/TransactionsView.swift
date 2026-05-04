//
//  TransactionsView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionsView: View {
    @Query private var transactions: [Transaction]
    @Query private var categories: [Category]
    @Environment(\.modelContext) var context
 
    var body: some View {
        NavigationStack {
            VStack {
                if transactions.count > 0 {
                    DateTransactionList()
                } else {
                    if categories.count > 0 {
                        ContentUnavailableView("No Transactions", systemImage: "sterlingsign.arrow.circlepath")
                            .padding(.top, -20) 
                    } else {
                        ContentUnavailableView("No Transactions", systemImage: "sterlingsign.arrow.circlepath", description: Text("Add a category to begin adding transactions"))
                            .padding(.top, -20)
                            
                    }
                }
            }
           
            .background(Rectangle().fill(.listBackground).ignoresSafeArea())
            
        }
    }
}

#Preview {
    TransactionsView()
}
