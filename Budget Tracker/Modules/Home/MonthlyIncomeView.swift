//
//  MonthlyIncomeView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/09/2024.
//

import SwiftUI
import SwiftData

struct MonthlyIncomeView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var displayPercentage: Bool = false
    
    var totalIncome: Double {
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
    
    var body: some View {
        HStack {
            Text("Income to Date")
                .font(.subheadline)
                .fontWeight(.semibold)
            
          
                Spacer()
                
                Text(totalIncome, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                .fontWeight(.bold)
                .font(.system(size: 32))
                .fontDesign(.rounded)
                .foregroundStyle(.cyan)
                
            
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MonthlyIncomeView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}

