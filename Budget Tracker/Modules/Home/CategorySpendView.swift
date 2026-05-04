//
//  CategorySpendView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI
import SwiftData

struct CategorySpendView: View {
    @Query private var categories: [Category]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var transactionType: String
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(sortedCategories, id: \.category) { categorySpend in
                if categorySpend.totalSpend > 0 {
                    CategorySpendBarView(
                        selectedMonth: $selectedMonth,
                        selectedYear: $selectedYear,
                        transactionType: $transactionType,
                        category: categorySpend.category,
                        totalSpend: categorySpend.totalSpend
                    )
                }
            }
        }
        .padding(.vertical)
    }
    
    private var sortedCategories: [(category: Category, totalSpend: Double)] {
        totalSpendForCategory.sorted {
            $0.totalSpend > $1.totalSpend
        }
    }
    
    private var totalSpendForCategory: [(category: Category, totalSpend: Double)] {
        var spendArray = [(category: Category, totalSpend: Double)]()
        let calendar = Calendar.current
        
        for category in categories {
            let transactionsInSelectedMonth = category.transactions?.filter {
                calendar.component(.month, from: $0.date) == selectedMonth &&
                calendar.component(.year, from: $0.date) == selectedYear &&
                $0.type == transactionType
            } ?? []
            
            let totalSpend = transactionsInSelectedMonth.reduce(0) { $0 + $1.amount }
            spendArray.append((category, totalSpend))
        }
        
        return spendArray
    }
}

#Preview {
    CategorySpendView(selectedMonth: .constant(5), selectedYear: .constant(2024), transactionType: .constant("Expenditure"))
}
