//
//  MonthlyChartView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 22/09/2024.
//

import Charts
import SwiftUI
import SwiftData

struct MonthlyChartView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var transactionType: String
    
    var cumulativeDailyTotals: [(day: Int, total: Double)] {
        let calendar = Calendar.current
        let filteredTransactions = transactions.filter { transaction in
            let transactionDate = transaction.date
            let month = calendar.component(.month, from: transactionDate)
            let year = calendar.component(.year, from: transactionDate)
            return month == selectedMonth && year == selectedYear && transaction.type == transactionType
        }
        
        let groupedTransactions = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.component(.day, from: transaction.date)
        }
        
        let dailyTotals = groupedTransactions.map { (day: Int, transactions: [Transaction]) -> (day: Int, total: Double) in
            let total = transactions.map { $0.amount }.reduce(0, +)
            return (day, total)
        }.sorted { (lhs: (day: Int, total: Double), rhs: (day: Int, total: Double)) -> Bool in
            lhs.day < rhs.day
        }
        
        var cumulativeTotal = 0.0
        return dailyTotals.map { (day, total) in
            cumulativeTotal += total
            return (day, cumulativeTotal)
        }
    }
    
    var body: some View {
        Chart(cumulativeDailyTotals, id: \.day) { (data: (day: Int, total: Double)) in
            LineMark(
                x: .value("Day", data.day),
                y: .value("Total", data.total)
            )
            
            .symbol(.diamond)
            .lineStyle(.init(lineWidth: 5))
            
            AreaMark(
                x: .value("Day", data.day),
                y: .value("Total", data.total)
            )
            .foregroundStyle(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.cyan.opacity(0.2),
                        Color.cyan.opacity(0.05)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
//        .chartXAxis {
//            AxisMarks(values: [1, 8, 15, 22, 28]) { value in
//                AxisValueLabel {
//                    if let day = value.as(Int.self) {
//                        Text("\(day)\(ordinalSuffix(for: day))")
//                    }
//                }
//            }
//        }
        .chartYAxis {
        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
        }
        .chartXAxis {
        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
        }
        .padding(.vertical)
    }
    
    private func ordinalSuffix(for day: Int) -> String {
        switch day {
        case 11...13:
            return "th"
        default:
            switch day % 10 {
            case 1:
                return "st"
            case 2:
                return "nd"
            case 3:
                return "rd"
            default:
                return "th"
            }
        }
    }
}
