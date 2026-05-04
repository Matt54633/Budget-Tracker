//
//  PieView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct PieView: View {
    @Query private var transactions: [Transaction]
    @Query private var categories: [Category]
    @State private var selectedSegmentIndex: Int?
    @State private var redrawID = UUID()
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var transactionType: String
    
    var body: some View {
        Chart {
            if transactionsByCategory.isEmpty {
                SectorMark(angle: .value("value", 360), innerRadius: .ratio(0.85), angularInset: 5)
                    .cornerRadius(100)
                    .foregroundStyle(.gray)
            } else {
                ForEach(sortedKeys.indices, id: \.self) { index in
                    SectorMark(angle: .value("Value", value(for: index)), innerRadius: .ratio(0.85), angularInset: 5)
                        .cornerRadius(100)
                        .foregroundStyle(colour(for: index))
                        .opacity(selectedCategory == nil || category(for: index) == selectedCategory ? 1.0 : 0.3)
                }
            }
        }
        .padding(7.5)
        .frame(width: 200, height: 200)
        .onAppear {
            redrawID = UUID()
        }
        .chartAngleSelection(value: $selectedSegmentIndex)
        .chartBackground { chartProxy in
            VStack {
                if selectedCategory == nil {
                    Text(filteredTransactions.count, format: .number)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    let transactionText = transactionType == "Expenditure" ? "Expense".pluralize(count: transactions.count) : "Income".pluralize(count: transactions.count)
                    
                    Text(transactionText)
                        .font(.caption)
                        .foregroundStyle(.gray)
                } else {
                    let categoryTransactions = filteredTransactions.filter { $0.category?.title == selectedCategory }
                    Text(categoryTransactions.count, format: .number)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    Text(selectedCategory ?? "")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    private var filteredTransactions: [Transaction] {
        transactions.filter {
            let transactionDate = $0.date
            let transactionMonth = Calendar.current.component(.month, from: transactionDate)
            let transactionYear = Calendar.current.component(.year, from: transactionDate)
            return transactionMonth == selectedMonth && transactionYear == selectedYear && $0.type == transactionType
        }
    }
    
    private var transactionsByCategory: [String: [Transaction]] {
        Dictionary(grouping: filteredTransactions) { $0.category?.title ?? "N/A" }
    }
    
    private var sortedKeys: [String] {
        transactionsByCategory.keys.sorted()
    }
    
    private var selectedCategory: String? {
        guard let index = selectedSegmentIndex else { return nil }
        return findSelectedCategory(value: index, transactionsByCategory: transactionsByCategory)
    }
    
    private func findSelectedCategory(value: Int, transactionsByCategory: [String: [Transaction]]) -> String? {
        var accumulatedValue: Double = 0.0
        let sortedCategories = transactionsByCategory.keys.sorted()
        
        let category = sortedCategories.first { category in
            accumulatedValue += Double(transactionsByCategory[category]?.count ?? 0)
            return Double(value) <= accumulatedValue
        }
        
        return category
    }
    
    private func category(for index: Int) -> String {
        sortedKeys[index]
    }
    
    private func colour(for index: Int) -> Color {
        let category = self.categoryObject(for: index)
        let colourName = category?.color ?? "blue"
        
        return customColorMappings[colourName, default: .blue]
    }
    
    private func categoryObject(for index: Int) -> Category? {
        let categoryName = self.category(for: index)
        return transactionsByCategory[categoryName]?.first?.category
    }
    
    private func value(for index: Int) -> Double {
        let category = self.category(for: index)
        return Double(transactionsByCategory[category]?.count ?? 0)
    }
}

#Preview {
    PieView(selectedMonth: .constant(5), selectedYear: .constant(2024), transactionType: .constant("Expenditure"))
}
