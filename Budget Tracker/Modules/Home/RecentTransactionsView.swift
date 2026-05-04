//
//  RecentTransactionsView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/09/2024.
//

import SwiftUI
import SwiftData

struct RecentTransactionsView: View {
    @Query private var transactions: [Transaction]
    @Environment(\.modelContext) var context
    @Binding var transactionType: String
    @State private var transactionToDelete: Transaction?
    @State private var showAlert: Bool = false
    
    var body: some View {
            let sortedTransactions = transactions.sorted { $0.date > $1.date }
            let filteredTransactions = sortedTransactions.filter { $0.type == transactionType }
        let recentTransactions = filteredTransactions.prefix(5)
        if !recentTransactions.isEmpty {
            ForEach(recentTransactions) { transaction in
                TransactionListItemView(transaction: transaction)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .swipeActions {
                        Button("Delete") {
                            transactionToDelete = transaction
                            showAlert = true
                        }
                        .tint(.red)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Warning"),
                            message: Text("Are you sure you want to delete this transaction?"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let transaction = transactionToDelete {
                                    context.delete(transaction)
                                }
                                
                            },
                            secondaryButton: .cancel()
                        )
                    }
            }
        } else  {
            ContentUnavailableView("No Recent Transactions", systemImage: "sterlingsign.arrow.circlepath")
        }
          
        
    }
}

#Preview {
    RecentTransactionsView(transactionType: .constant("Expenditure"))
}
