//
//  SpendPercentageView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/09/2024.
//

import SwiftUI
import SwiftData

struct SpendPercentageView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Query private var subscriptions: [Subscription]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var displayPercentage: Bool = false
    
    var incomeToDate: Double {
        transactions
            .filter { transaction in
                let calendar = Calendar.current
                let transactionDate = transaction.date
                let month = calendar.component(.month, from: transactionDate)
                let year = calendar.component(.year, from: transactionDate)
                return month == selectedMonth && year == selectedYear && transaction.type == "Income"
            }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var totalTransactionAmount: Double {
        transactions
            .filter {
                let transactionDate = $0.date
                let transactionMonth = Calendar.current.component(.month, from: transactionDate)
                let transactionYear = Calendar.current.component(.year, from: transactionDate)
                return transactionMonth == selectedMonth && transactionYear == selectedYear && $0.type == "Expenditure"
            }
            .reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                    let percentage = (totalTransactionAmount / incomeToDate) * 100
                    Text("Income Spent")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                if incomeToDate > 0 {
                    Text(String(format: "%.1f%%", percentage))
                        .fontWeight(.bold)
                        .font(.title3)
                        .fontDesign(.rounded)
                        .foregroundStyle(percentage > 100 ? .red : .cyan)
                    
                } else {
                    Text("N/A")
                        .fontWeight(.bold)
                        .font(.title3)
                        .fontDesign(.rounded)
                        .foregroundStyle(.cyan)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    SpendPercentageView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}

#Preview {
    SpendPercentageView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
