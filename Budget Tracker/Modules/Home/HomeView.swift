//
//  HomeView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData
import SWTools

struct HomeView: View {
    @State private var loadedMonths: [MonthYear] = []
    @Query private var transactions: [Transaction]
    @State private var transactionType: String = "Expenditure"
    @State private var selectedDate: MonthYear = MonthYear(month: Calendar.current.component(.month, from: Date()), year: Calendar.current.component(.year, from: Date()))
    let months = Calendar.current.monthSymbols
    @State private var currentMonth: MonthYear
    @State private var transactionsByMonth: [MonthYear: [Transaction]] = [:]
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        currentMonth = MonthYear(month: Calendar.current.component(.month, from: Date()), year: Calendar.current.component(.year, from: Date()))
        _loadedMonths = State(initialValue: [currentMonth])
    }

    var body: some View {
        NavigationStack {
            VStack {
                if !transactions.isEmpty {
                    if let selectedMonth = loadedMonths.first(where: { $0 == selectedDate }) {
                        let transactionsForMonth = transactionsByMonth[selectedMonth] ?? []

                            HomeTabView(month: .constant(selectedMonth.month), year: .constant(selectedMonth.year), transactionType: $transactionType, transactionsForMonth: transactionsForMonth)
                                .id(selectedMonth)
                    }
                } else {
                    ContentUnavailableView("No Transactions", systemImage: "sterlingsign.arrow.circlepath", description: Text("Add a transaction to get started!"))
                        .padding(.top, -20)
                }
            }
            .onAppear {
                loadAdjacentMonths(for: selectedDate)
                precomputeTransactionsByMonth()
            }
            .onChange(of: selectedDate) {
                loadAdjacentMonths(for: selectedDate)
            }
            .toolbar {
                if !transactions.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                        } label: {
                            Text("\(months[selectedDate.month - 1])" + (selectedDate.year == Calendar.current.component(.year, from: Date()) ? "" : " \(selectedDate.year)"))
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                .font(.subheadline)
                                .frame(minWidth: 95)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(.listItemBackground)
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if let currentIndex = loadedMonths.sorted(by: { $0.year < $1.year || ($0.year == $1.year && $0.month < $1.month) }).firstIndex(of: selectedDate), currentIndex > 0 {
                                selectedDate = loadedMonths[currentIndex - 1]
                            }
                            hapticFeedback(.medium)
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .tint(.listItemBackground)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        Picker("Type", selection: $transactionType) {
                            Image("sterlingsign.circle.fill.badge.minus").tag("Expenditure")
                            Image("sterlingsign.circle.fill.badge.plus").tag("Income")
                        }
                        .frame(width: 100)
                        .font(.caption2)
                        .labelsHidden()
                        .pickerStyle(.segmented)
                        
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if let currentIndex = loadedMonths.sorted(by: { $0.year < $1.year || ($0.year == $1.year && $0.month < $1.month) }).firstIndex(of: selectedDate), currentIndex < loadedMonths.count - 1 {
                                selectedDate = loadedMonths[currentIndex + 1]
                            }
                            hapticFeedback(.medium)
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.circle)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .tint(.listItemBackground)
                    }
                }
            }
            .background(Rectangle().fill(.listBackground).ignoresSafeArea())
        }
    }

    private func loadAdjacentMonths(for date: MonthYear) {
        let previousMonth = MonthYear(month: date.month == 1 ? 12 : date.month - 1,
                                      year: date.month == 1 ? date.year - 1 : date.year)
        let nextMonth = MonthYear(month: date.month == 12 ? 1 : date.month + 1,
                                  year: date.month == 12 ? date.year + 1 : date.year)

        if !loadedMonths.contains(previousMonth) {
            loadedMonths.insert(previousMonth, at: 0)
        }
        if !loadedMonths.contains(nextMonth) {
            loadedMonths.append(nextMonth)
        }
    }

    private func precomputeTransactionsByMonth() {
        transactionsByMonth = Dictionary(grouping: transactions) { transaction in
            let transactionDate = Calendar.current.dateComponents([.month, .year], from: transaction.date)
            return MonthYear(month: transactionDate.month!, year: transactionDate.year!)
        }
    }
}

#Preview {
    HomeView()
}
