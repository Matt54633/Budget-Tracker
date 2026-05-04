//
//  TotalTransactionsView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI
import SwiftData

struct TotalTransactionsView: View {
    @Query private var transactions: [Transaction]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    var totalTransactionsForSelectedMonth: Int {
        return transactions
            .filter { transaction in
                let transactionDate = transaction.date
                let month = Calendar.current.component(.month, from: transactionDate)
                let year = Calendar.current.component(.year, from: transactionDate)
                return month == selectedMonth && year == selectedYear && transaction.type == "Expenditure"
            }
            .count
    }
    
    var body: some View {
        HStack {
            Text("Total Expenses")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(totalTransactionsForSelectedMonth, format: .number)
                .fontWeight(.bold)
                .font(.title2)
                .fontDesign(.rounded)
                .foregroundStyle(.cyan)
            
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TotalTransactionsView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
