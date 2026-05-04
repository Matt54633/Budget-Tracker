//
//  TransactionWeekTabView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionWeekTabView: View {
    @Query private var categories: [Category]
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    var sortedDays: [Dictionary<Date, [Transaction]>.Keys.Element]
    var transactionsByDay: Dictionary<Date, [Transaction]>
    @State private var sectionHeaders: [Date: String] = [:]
    @State private var showAlert: Bool = false
    @State private var transactionToDelete: Transaction?
    
    var body: some View {
        if transactionsByDay.isEmpty {
            List {
                ContentUnavailableView("No Transactions", systemImage: "sterlingsign.arrow.circlepath")
            }
            .padding(.top, -20)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                            NavigationLink {
                                TransactionFormView(editFlag: false)
                            } label: {
                                CreateButton()
                            }
                    }
                    .padding(.top)
                }
            }
        } else {
            List {
                ForEach(sortedDays.sorted(by: >), id: \.self) { day in
//                    Section(header: TransactionHeaderView(title: sectionHeaders[day] ?? "")) {
                        ForEach((transactionsByDay[day] ?? []).sorted(by: { $0.date > $1.date }), id: \.self) { transaction in
                            TransactionListItemView(transaction: transaction)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                                .swipeActions {
                                    Button("Delete") {
                                        transactionToDelete = transaction
                                        showAlert = true
                                    }
                                    .tint(.red)
                                }
                        }
//                    }
//                    .textCase(.none)
                    .onAppear {
                        sectionHeaders[day] = getSectionHeader(for: day)
                    }
                }
               
                
                
            }
            .padding(.top, -20)
            .listRowSpacing(12)
            .listSectionSpacing(5)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        
                        Section(header: TotalHeaderView(title: calculateInGoings())) {}
                        Section(header: TotalHeaderView(title: calculateOutGoings())) {}

                        
                        if categories.count != 0 {
                            NavigationLink {
                                TransactionFormView(editFlag: false)
                            } label: {
                                CreateButton()
                            }
                        }
                        
                    }
                    .padding(.top)
                }
            }
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text("Are you sure you want to delete this transaction?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let transaction = transactionToDelete {
                            context.delete(transaction)
                        }
                        
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    func calculateInGoings() -> String {
        let total = transactionsByDay.values
            .flatMap { $0 }
            .filter { $0.type == "Income" }
            .reduce(0) { $0 + $1.amount }
        
        return String("In - \(total.formatted(.currency(code: Locale.current.currency?.identifier ?? "GBP")))")
    }

    func calculateOutGoings() -> String {
        let total = transactionsByDay.values
            .flatMap { $0 }
            .filter { $0.type == "Expenditure" }
            .reduce(0) { $0 + $1.amount }
        
        return String("Out - \(total.formatted(.currency(code: Locale.current.currency?.identifier ?? "GBP")))")
    }
    
    func getSectionHeader(for day: Date) -> String {
        if Calendar.current.isDateInToday(day) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(day) {
            return "Yesterday"
        } else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .ordinal
            let dayOfMonth = Calendar.current.component(.day, from: day)
            let dayString = numberFormatter.string(from: NSNumber(value: dayOfMonth))
            
            let monthAndYearFormatter = DateFormatter()
            if Calendar.current.isDate(day, equalTo: Date(), toGranularity: .year) {
                monthAndYearFormatter.dateFormat = "MMM"
            } else {
                monthAndYearFormatter.dateFormat = "MMM yyyy"
            }
            let monthAndYearString = monthAndYearFormatter.string(from: day)
            
            return "\(dayString!) \(monthAndYearString)"
        }
    }
}
