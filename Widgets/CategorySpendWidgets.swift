//
//  CategorySpendWidgets.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 28/05/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct CategorySpendProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (CategorySpendSimpleEntry) -> Void) {
        let entry = CategorySpendSimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CategorySpendSimpleEntry>) -> Void) {
        var entries: [CategorySpendSimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CategorySpendSimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
    
    func placeholder(in context: Context) -> CategorySpendSimpleEntry {
        CategorySpendSimpleEntry(date: Date())
    }
}

struct CategorySpendSimpleEntry: TimelineEntry {
    let date: Date
}

struct CategorySpendWidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    @Query private var transactions: [Transaction]
    @Query private var categories: [Category]
    @Query private var budgets: [Budget]
    @State private var date = Date()
    var entry: CategorySpendProvider.Entry
    
    var currentMonthTransactionsSum: Double {
        let calendar = Calendar.current
        let currentMonthTransactions = transactions.filter {
            calendar.isDate($0.date, equalTo: date, toGranularity: .month)
        }
        return currentMonthTransactions.reduce(0) { $0 + $1.amount }
    }
    
    var budgetSpentFraction: Double {
        guard let budget = budgets.first else { return 0 }
        return currentMonthTransactionsSum / budget.amount
    }
    
    var budgetAmount: Double {
        guard let budget = budgets.first else { return 0 }
        return budget.amount
    }
    
    func totalSpendForCategory(category: Category) -> Double {
        let calendar = Calendar.current
        let categoryTransactions = transactions.filter {
            $0.category?.title == category.title &&
            calendar.isDate($0.date, equalTo: date, toGranularity: .month)
            && $0.type == "Expenditure"
        }
        let totalSpend = categoryTransactions.reduce(0) { $0 + $1.amount }
        return totalSpend
    }
    
    var topSpendingCategories: [Category] {
        let categorySpends = categories.map { category -> (category: Category, spend: Double) in
            let spend = totalSpendForCategory(category: category)
            return (category, spend)
        }
        let sortedCategorySpends = categorySpends.sorted { $0.spend > $1.spend }
        let topCategories = Array(sortedCategorySpends.prefix(6)).map { $0.category }
        return topCategories
    }
     
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Top Categories")
                   
                Spacer()
                
                Text(Date().month)
                    .font(.caption)
                    .foregroundStyle(.cyan)
                    .fontWeight(.semibold)
                    
            }
            .fontWeight(.bold)
            .fontDesign(.rounded)
            
            
            Spacer()
            
            ForEach(topSpendingCategories, id: \.title) { category in
                VStack(alignment: .leading) {
                    HStack {
                        Text(category.title)
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(totalSpendForCategory(category: category), format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                        
                    }
                    .padding(.bottom, -2.5)
                    
                    GeometryReader { geometry in
                            
                            let trackWidth = geometry.size.width
                            let trackX = trackWidth * CGFloat(totalSpendForCategory(category: category) / budgetAmount)
                            
                            Capsule()
                                .frame(width: trackWidth, height: 12)
                                .foregroundStyle(colorScheme == .dark ? .listItemBackground : .gray.opacity(0.14))
                            
                            Capsule()
                                .frame(width: trackWidth, height: 12)
                                .foregroundStyle(customColorMappings[category.color] ?? .blue)
                                .mask(
                                    HStack {
                                        Rectangle()
                                            .frame(width: trackX)
                                        Spacer()
                                    }
                                )
                    }
                    
                }
                .frame(height: 40)
            }
                                    
        }
        .containerBackground(.listBackground, for: .widget)
    }
}

struct CategorySpendWidgets: Widget {
    let kind: String = "CategorySpendWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CategorySpendProvider()) { entry in
            CategorySpendWidgetsEntryView(entry: entry)
                .modelContainer(for: [Transaction.self, Budget.self, Category.self])
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("Top Categories")
        .description("View your top spending categories")
    }
}

#Preview(as: .systemLarge) {
    CategorySpendWidgets()
} timeline: {
    CategorySpendSimpleEntry(date: .now)
    CategorySpendSimpleEntry(date: .now.advanced(by: 1500))
}
