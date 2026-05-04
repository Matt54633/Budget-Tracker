//
//  Widgets.swift
//  Widgets
//
//  Created by Matt Sullivan on 28/05/2024.
//

import WidgetKit
import SwiftUI
import SwiftData

struct PieTransactionsProvider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct PieTransactionsWidgetsEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @State private var date = Date()
    var entry: PieTransactionsProvider.Entry
    
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
        VStack {
            HStack(alignment: .top) {
                
               
              
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(.clear)
                        .stroke(.cyan.opacity(0.3), lineWidth: 6)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(budgetSpentFraction))
                        .stroke(.cyan, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                   
                }
                .frame(width: 50, height: 50)
                .fontDesign(.rounded)
                .containerBackground(colorScheme == .dark ? .black : .white, for: .widget)
            }
            
            Spacer()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(Date().month)
                        
                            .font(.caption2)
                            .fontWeight(.semibold)
                           
                            .foregroundStyle(.cyan)
                        
                                            
                        
                        Text(currentMonthTransactionsSum, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        
                        Text(budgetAmount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                            .font(.caption2)
                            .foregroundStyle(.gray)
                            .fontWeight(.semibold)
                        
                        
                    }
                    
                    Spacer()
                }
             
               
                
            }
        }
        .padding(EdgeInsets(top: -2.5, leading: -2.5, bottom: -2.5, trailing: -2.5))
        .fontDesign(.rounded)
    }
}

struct PieTransactionsWidgets: Widget {
    let kind: String = "PieWidgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PieTransactionsProvider()) { entry in
            PieTransactionsWidgetsEntryView(entry: entry)
                .modelContainer(for: [Transaction.self, Budget.self])
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Budget Pie")
        .description("View your monthly budget and total spent.")
    }
}

#Preview(as: .systemSmall) {
    PieTransactionsWidgets()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now.advanced(by: 1500))
}
