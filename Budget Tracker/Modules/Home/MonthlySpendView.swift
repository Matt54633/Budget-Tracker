//
//  MonthlySpendView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI
import SwiftData

struct MonthlySpendView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var displayPercentage: Bool = false
    
    var totalSpend: Double {
        transactions
            .filter { transaction in
                let calendar = Calendar.current
                let transactionDate = transaction.date
                let month = calendar.component(.month, from: transactionDate)
                let year = calendar.component(.year, from: transactionDate)
                return month == selectedMonth && year == selectedYear && transaction.type == "Expenditure"
            }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var body: some View {
        HStack {
            Text("Budget Remaining")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            if let budget = budgets.first {
                let availableBudget = max(0, budget.amount - totalSpend)
                
                Spacer()
                
                Group {
                    if !displayPercentage {
                        Text(availableBudget, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        
                    } else {
                        let percentage = budget.amount == 0 ? 0 : availableBudget / budget.amount
                        Text(percentage, format: .percent.precision(.fractionLength(0...0)))
                        
                    }
                }
                .fontWeight(.bold)
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundStyle(.cyan)
                
            }
        }
        .padding(.vertical, 4)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { isPressing in
            displayPercentage = isPressing
        }) {
        }
    }
}

#Preview {
    MonthlySpendView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
