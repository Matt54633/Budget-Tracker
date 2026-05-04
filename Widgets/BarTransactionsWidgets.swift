//
//  BarTransactionsWidgets.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 28/05/2024.
//

import WidgetKit
import SwiftUI
import SwiftData
import Charts

struct BarTransactionsProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (BarSimpleEntry) -> Void) {
        let entry = BarSimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BarSimpleEntry>) -> Void) {
        var entries: [BarSimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = BarSimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
    
    func placeholder(in context: Context) -> BarSimpleEntry {
        BarSimpleEntry(date: Date())
    }
}

struct BarSimpleEntry: TimelineEntry {
    let date: Date
}

struct BarTransactionsWidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @State private var date = Date()
    var entry: BarTransactionsProvider.Entry
    
    var currentMonthTransactionsSum: Double {
        let calendar = Calendar.current
        let currentMonthTransactions = transactions.filter {
            calendar.isDate($0.date, equalTo: date, toGranularity: .month)
        }
        return currentMonthTransactions.filter{ $0.type == "Expenditure" }.reduce(0) { $0 + $1.amount }
    }
    
    var budgetSpentFraction: Double {
        guard let budget = budgets.first else { return 0 }
        return currentMonthTransactionsSum / budget.amount
    }
    
    var budgetAmount: Double {
        guard let budget = budgets.first else { return 0 }
        return budget.amount
    }
    
    var body: some View {
        GeometryReader { geometry in

            VStack(alignment: .leading, spacing: 1) {
            
                Text(Date().month)
                
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.cyan)
                
                Text(currentMonthTransactionsSum, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                
                Text(budgetAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                    .foregroundStyle(.gray)
                    .font(.caption2)
                    .fontWeight(.semibold)
                

                
                Spacer()
                
                let trackWidth = geometry.size.width
                let trackX = trackWidth * CGFloat(currentMonthTransactionsSum / budgetAmount)
                
                ZStack {
                    Capsule()
                        .frame(width: trackWidth, height: 20)
                        .foregroundStyle(.cyan.opacity(0.2))
                    
                    Capsule()
                        .frame(width: trackWidth, height: 20)
                        .foregroundStyle(.cyan)
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
        .fontDesign(.rounded)
        .containerBackground(colorScheme == .dark ? .black : .white, for: .widget)
    }
}

struct BarTransactionsWidgets: Widget {
    let kind: String = "BarWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BarTransactionsProvider()) { entry in
            BarTransactionsWidgetsEntryView(entry: entry)
                .modelContainer(for: [Transaction.self, Budget.self])
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Budget Bar")
        .description("View your monthly budget and total spent.")
    }
}

#Preview(as: .systemMedium) {
    BarTransactionsWidgets()
} timeline: {
    BarSimpleEntry(date: .now)
    BarSimpleEntry(date: .now.advanced(by: 1500))
}
