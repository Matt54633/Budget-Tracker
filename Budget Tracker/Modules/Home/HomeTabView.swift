//
//  HomeTabView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI

struct HomeTabView: View {
    @Binding var month: Int
    @Binding var year: Int
    @Binding var transactionType: String
    var transactionsForMonth: [Transaction]
    @State private var displayTransactionSheet: Bool = false
    
    var body: some View {
        Group {
            if transactionsForMonth.isEmpty {
                List {
                    ContentUnavailableView("No Transactions", systemImage: "sterlingsign.arrow.circlepath")
                }
                .padding(.top, -20)
            } else {
                List {
                    transactionSection
                    if isCurrentMonth() {
                        recentTransactionSection
                    }
                    breakdownSection
                }
                .padding(.top, -20)
                .listRowSpacing(12)
                .safeAreaPadding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                .sheet(isPresented: $displayTransactionSheet) {
                    TransactionFormView(transactionType: transactionType)
                        .presentationDetents([.medium])
                }
            }
        }
    }
    
    private var transactionSection: some View {
//        Section(header: TransactionHeaderView(title: transactionType == "Expenditure" ? "Expenses" : "Income")) {
        Group {
            if transactionType == "Expenditure" {
                MonthlyBudgetView(selectedMonth: $month, selectedYear: $year)
                    .frame(maxWidth: .infinity)
                MonthlySpendView(selectedMonth: $month, selectedYear: $year)
                TotalTransactionsView(selectedMonth: $month, selectedYear: $year)
            } else {
                MonthlyTotalIncomeView(selectedMonth: $month, selectedYear: $year)
                MonthlyExpectedIncomeView(selectedMonth: $month, selectedYear: $year)
                SpendPercentageView(selectedMonth: $month, selectedYear: $year)
            }
        }
//        }
    }
    
    private var recentTransactionSection: some View {
        Section(header: RecentTransactionHeaderView(displaySheet: $displayTransactionSheet, title: "Recent Transactions")) {
            RecentTransactionsView(transactionType: $transactionType)
        }
    }
    
    private var breakdownSection: some View {
           Section(header: TransactionHeaderView(title: transactionType == "Expenditure" ? "Expenditure Breakdown" : "Income Breakdown")) {
               if hasTransactionsForType() {
                   CategorySpendView(selectedMonth: $month, selectedYear: $year, transactionType: $transactionType)
                 
               }
               
//               PieView(selectedMonth: $month, selectedYear: $year, transactionType: $transactionType)
//                   .frame(maxWidth: .infinity)
           }
       }
    
    private func isCurrentMonth() -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        return month == currentMonth && year == currentYear
    }
    
    private func hasTransactionsForType() -> Bool {
         return transactionsForMonth.contains { $0.type == transactionType }
     }
}

#Preview {
    HomeTabView(month: .constant(5), year: .constant(2024), transactionType: .constant("Expenditure"), transactionsForMonth: [])
}
