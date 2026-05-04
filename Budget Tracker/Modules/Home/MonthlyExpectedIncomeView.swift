//
//  MonthlyExpectedIncomeView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 29/09/2024.
//


import SwiftUI
import SwiftData

struct MonthlyExpectedIncomeView: View {
    @Query private var transactions: [Transaction]
    @Query private var budgets: [Budget]
    @Query private var subscriptions: [Subscription]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var displayPercentage: Bool = false
    
    var expectedIncome: Double {
        var subscriptionIncome: Double = 0.0
        var processedSubscriptions = Set<String>()
        
        for subscription in subscriptions where subscription.type == "Income" {
            if processedSubscriptions.contains(subscription.id) {
                continue
            }
            
            switch subscription.repeatFrequency {
            case "Weekly":
                subscriptionIncome += subscription.amount * 4
            case "Yearly":
                subscriptionIncome += subscription.amount / 12
            case "Monthly":
                subscriptionIncome += subscription.amount
            default:
                break
            }
            
            processedSubscriptions.insert(subscription.id)
        }
        
        return subscriptionIncome
    }
    
    var body: some View {
        HStack {
            Text("Recurring Income")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(expectedIncome, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                .fontWeight(.bold)
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundStyle(.cyan)
            
           
        }
        .fontDesign(.rounded)
        .padding(.vertical, 4)
    }
}

#Preview {
    MonthlyExpectedIncomeView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
