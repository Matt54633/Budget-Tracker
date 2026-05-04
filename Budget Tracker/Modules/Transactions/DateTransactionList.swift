//
//  DateTransactionList.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData
import SWTools

struct DateTransactionList: View {
    @Query private var transactions: [Transaction]
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @State private var loadedWeeks: [WeekYear] = []
    @State private var selectedWeek: WeekYear = WeekYear(week: Date().weekOfYear, year: Date().year)
    
    var transactionsByWeek: [WeekYear: [Transaction]] {
        Dictionary(grouping: transactions, by: { WeekYear(week: $0.date.weekOfYear, year: $0.date.year) })
    }
    
    init() {
        let currentWeek = WeekYear(week: Date().weekOfYear, year: Date().year)
        _selectedWeek = State(initialValue: currentWeek)
        _loadedWeeks = State(initialValue: [currentWeek])
        loadAdjacentWeeks(for: currentWeek)
    }
    
    var body: some View {
        VStack {
            ForEach(loadedWeeks, id: \.self) { week in
                if week == selectedWeek {
                    let transactionsThisWeek = transactionsByWeek[week] ?? []
                    let transactionsByDay = Dictionary(grouping: transactionsThisWeek, by: { $0.date.startOfDay })
                    let sortedDays = transactionsByDay.keys.sorted()
                    
                
                        TransactionWeekTabView(sortedDays: sortedDays, transactionsByDay: transactionsByDay)   
                        .id(week)
                }
            }
        }
        .onAppear {
            loadAdjacentWeeks(for: selectedWeek)
        }
        .onChange(of: selectedWeek) {
            loadAdjacentWeeks(for: selectedWeek)
        }
        .toolbar {
            
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Text(getWeekLabel())
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .font(.subheadline)
                        .frame(minWidth: 95)

                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.listItemBackground)
            }
       
            
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    if let currentIndex = loadedWeeks.firstIndex(of: selectedWeek), currentIndex > 0 {
                        selectedWeek = loadedWeeks[currentIndex - 1]
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

            
            
                    Button {
                        if let currentIndex = loadedWeeks.firstIndex(of: selectedWeek), currentIndex < loadedWeeks.count - 1 {
                            selectedWeek = loadedWeeks[currentIndex + 1]
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
    
    private func loadAdjacentWeeks(for week: WeekYear) {
        let previousWeek = WeekYear(week: week.week == 1 ? 52 : week.week - 1,
                                    year: week.week == 1 ? week.year - 1 : week.year)
        let nextWeek = WeekYear(week: week.week == 52 ? 1 : week.week + 1,
                                year: week.week == 52 ? week.year + 1 : week.year)
        
        if !loadedWeeks.contains(previousWeek) {
            loadedWeeks.insert(previousWeek, at: 0)
        }
        if !loadedWeeks.contains(nextWeek) {
            loadedWeeks.append(nextWeek)
        }
    }
    
    func getStartDateStringSuffix() -> String {
        let now = Date()
        let calendar = Calendar.current
        let startMonth = calendar.component(.month, from: selectedWeek.startOfWeek)
        let currentMonth = calendar.component(.month, from: now)

        var suffix = ""

        if startMonth != currentMonth {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            suffix += " \(formatter.string(from: selectedWeek.startOfWeek))"
        }

        return suffix
    }
    
    func getEndDateStringSuffix() -> String {
        let now = Date()
        let calendar = Calendar.current
        let startMonth = calendar.component(.month, from: selectedWeek.startOfWeek)
        let endMonth = calendar.component(.month, from: selectedWeek.endOfWeek)
        let currentMonth = calendar.component(.month, from: now)
        let startYear = calendar.component(.year, from: selectedWeek.startOfWeek)
        let endYear = calendar.component(.year, from: selectedWeek.endOfWeek)
        let currentYear = calendar.component(.year, from: now)

        var suffix = ""

        if startMonth != currentMonth || endMonth != currentMonth {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            suffix += " \(formatter.string(from: selectedWeek.endOfWeek))"
        }

        if startYear != currentYear || endYear != currentYear {
            suffix += " \(endYear)"
        }

        return suffix
    }
    
    func getWeekLabel() -> String {
        let now = Date()
        let _ = Calendar.current
        let currentWeek = WeekYear(week: now.weekOfYear, year: now.year)

        if selectedWeek == currentWeek {
            return "This Week"
        } else if selectedWeek.week == currentWeek.week - 1 && selectedWeek.year == currentWeek.year {
            return "Last Week"
        } else if selectedWeek.week == currentWeek.week + 1 && selectedWeek.year == currentWeek.year {
            return "Next Week"
        } else {
            return "\(selectedWeek.startOfWeek.ordinalDay)\(getStartDateStringSuffix()) - \(selectedWeek.endOfWeek.ordinalDay)\(getEndDateStringSuffix())"
        }
    }
}


#Preview {
    DateTransactionList()
}
