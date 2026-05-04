//
//  BudgetPieView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct BudgetPieView: View {
    @Query private var transactions: [Transaction]
    @Query private var budget: [Budget]
    @State private var redrawID = UUID()
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var displayPercentage: Bool = false
    
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
    
    var budgetAmount: Double {
        budget.first?.amount ?? 0
    }
    
    var budgetUsage: Double {
        budgetAmount == 0 ? 0 : totalTransactionAmount / budgetAmount
    }
    
    var body: some View {
       
        
        
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                
                
                if !displayPercentage {
                    Text(totalTransactionAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                    Text(budgetAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                } else {
                    Text(budgetUsage, format: .percent.precision(.fractionLength(0...0)))
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                    Text("Spent")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                }
                
            }
            .fontDesign(.rounded)
            
            Spacer()
            
            Chart {
                if budgetUsage < 1 {
                    SectorMark(angle: .value("Remaining Budget", 360 * (1 - budgetUsage)), innerRadius: .ratio(0.7), angularInset: 0)
                        .cornerRadius(0)
                        .foregroundStyle(.quaternary)
                }
            }
            .overlay {
                Chart {
                    SectorMark(angle: .value("Budget Usage", 360 *   budgetUsage), innerRadius: .ratio(0.7), angularInset: 0)
                        .cornerRadius(100)
                        .foregroundStyle(.cyan)
                    if budgetUsage < 1 && budgetUsage != 0.0 {
                        SectorMark(angle: .value("Remaining Budget", 360 * (1 - budgetUsage)), innerRadius: .ratio(0.85), angularInset: 0)
                            .cornerRadius(0)
                            .foregroundStyle(.clear)
                    }
                }
            }
            
            .onAppear {
                redrawID = UUID()
            }
            .frame(width: 62, height: 62)
           
        }
        .onLongPressGesture(minimumDuration: .infinity, pressing: { isPressing in
            displayPercentage = isPressing
        }) {
        }
        
        
//        Chart {
//            if budgetUsage < 1 {
//                SectorMark(angle: .value("Remaining Budget", 360 * (1 - budgetUsage)), innerRadius: .ratio(0.85), angularInset: 0)
//                    .cornerRadius(0)
//                    .foregroundStyle(.quaternary)
//            }
//        }
//        .overlay {
//            Chart {
//                SectorMark(angle: .value("Budget Usage", 360 *   budgetUsage), innerRadius: .ratio(0.85), angularInset: 0)
//                    .cornerRadius(100)
//                    .foregroundStyle(.cyan)
//                if budgetUsage < 1 && budgetUsage != 0.0 {
//                    SectorMark(angle: .value("Remaining Budget", 360 * (1 - budgetUsage)), innerRadius: .ratio(0.85), angularInset: 0)
//                        .cornerRadius(0)
//                        .foregroundStyle(.clear)
//                }
//            }
//        }
//        .onAppear {
//            redrawID = UUID()
//        }
//        .padding(7.5)
//        .frame(width: 240, height: 240)
//        .onLongPressGesture(minimumDuration: .infinity, pressing: { isPressing in
//            displayPercentage = isPressing
//        }) {
//        }
//        .chartBackground { chartProxy in
//            VStack {
//                if !displayPercentage {
//                    Text(totalTransactionAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                    Text("Spent of ")       .font(.caption)
//                        .foregroundStyle(.gray) + Text(budgetAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
//                        .font(.caption)
//                        .foregroundStyle(.gray)
//                } else {
//                    Text(budgetUsage, format: .percent.precision(.fractionLength(0...0)))
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                    Text("Spent")
//                        .font(.caption)
//                        .foregroundStyle(.gray)
//                }
//                
//            }
//            .fontDesign(.rounded)
//            
//        }
    }
}

#Preview {
    BudgetPieView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
