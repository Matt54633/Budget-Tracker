//
//  BudgetDisplayView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI
import SwiftData

struct BudgetDisplayView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    var body: some View {
        let filteredTransactions = transactions.filter { transaction in
            let transactionDate = Calendar.current.dateComponents([.year, .month], from: transaction.date)
            return transactionDate.year == selectedYear && transactionDate.month == selectedMonth
        }
        
        let totalSpend = filteredTransactions.reduce(0) { $0 + $1.amount }

        VStack {
            Text("Budget")
                .fontWeight(.semibold)
                .padding(.top)

            GeometryReader { geometry in
                if let budget = budgets.first {
                    let trackWidth = geometry.size.width
                    let trackX = trackWidth * CGFloat(totalSpend / budget.amount)
                    
                        Capsule()
                            .frame(width: trackWidth, height: 30)
                            .foregroundStyle(.pink.quaternary)
                        
                        Capsule()
                            .frame(width: trackWidth, height: 30)
                            .foregroundStyle(.pink)
                            .mask(
                                HStack {
                                    Rectangle()
                                        .frame(width: trackX)
                                    Spacer()
                                }
                            )
                    

                }
            }
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(.thickMaterial)
        )
    }
}

#Preview {
    BudgetDisplayView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
