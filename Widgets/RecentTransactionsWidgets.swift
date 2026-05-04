//
//  RecentTransactionsWidgets.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 28/05/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct RecentTransactionsProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (RecentTransactionsSimpleEntry) -> Void) {
        let entry = RecentTransactionsSimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<RecentTransactionsSimpleEntry>) -> Void) {
        var entries: [RecentTransactionsSimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = RecentTransactionsSimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
    
    func placeholder(in context: Context) -> RecentTransactionsSimpleEntry {
        RecentTransactionsSimpleEntry(date: Date())
    }
}

struct RecentTransactionsSimpleEntry: TimelineEntry {
    let date: Date
}

struct RecentTransactionsWidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @State private var date = Date()
    var entry: RecentTransactionsProvider.Entry
    
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
    
    var recentTransactions: [Transaction] {
         let sortedTransactions = transactions.sorted { $0.date > $1.date }
         return Array(sortedTransactions.prefix(7))
     }
     
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Transactions")
                .fontWeight(.bold)
                .fontDesign(.rounded)            
            ForEach(recentTransactions, id: \.id) { transaction in
                if let category = transaction.category {
                    HStack {
                        UnevenRoundedRectangle(topLeadingRadius: 7.5, bottomLeadingRadius: 7.5, bottomTrailingRadius: 0, topTrailingRadius: 0)
                            .fill(customColorMappings[category.color] ?? .blue)
                            .frame(width: 7.5)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(transaction.title)
                                .fontWeight(.semibold)
                                .font(.system(size: 12))
                                .lineLimit(1)
                                .padding(.leading, 2.5)
                            
                            Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 9))
                                .foregroundStyle(.gray)
                                .padding(.leading, 2.5)
                        }
                        
                        Spacer()
                        
                        
                        Group {
                            Text(transaction.type == "Expenditure" ? "- " : "+ ") + Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                        }
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .padding(.trailing, 10)
                        
                    }
                    .background(UnevenRoundedRectangle(topLeadingRadius: 7.5, bottomLeadingRadius: 7.5, bottomTrailingRadius: 7.5, topTrailingRadius: 7.5).fill(.listItemBackground))
                  
                    .frame(height: 35)
                }
            }
            
            Spacer()
            
        }
        .padding(.bottom, -2.5)
        .containerBackground(.listBackground, for: .widget)
    }
}

struct RecentTransactionsWidgets: Widget {
    let kind: String = "RecentTransactionsWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecentTransactionsProvider()) { entry in
            RecentTransactionsWidgetsEntryView(entry: entry)
                .modelContainer(for: [Transaction.self, Budget.self, Category.self])
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("Recent Transactions")
        .description("View your recent transactions")
    }
}

#Preview(as: .systemSmall) {
    RecentTransactionsWidgets()
} timeline: {
    RecentTransactionsSimpleEntry(date: .now)
    RecentTransactionsSimpleEntry(date: .now.advanced(by: 1500))
}
