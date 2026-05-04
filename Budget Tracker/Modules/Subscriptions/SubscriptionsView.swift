//
//  SubscriptionsView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 19/05/2024.
//

import SwiftUI
import SwiftData

struct SubscriptionsView: View {
    @Query private var categories: [Category]
    @Query private var subscriptions: [Subscription]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack {
                if !subscriptions.isEmpty {
                    SubscriptionsListView()
                } else {
                    ContentUnavailableView("No Subscriptions", systemImage: "square.grid.2x2.fill")
                        .padding(.top, -20)
                }
            }
            
            
     
            
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Section(header: TotalHeaderView(title: calculateInGoings())) {}
                        Section(header: TotalHeaderView(title: calculateOutGoings())) {}
                        
                        
                        if categories.count != 0 {
                            NavigationLink {
                                SubscriptionFormView(editFlag: false)
                            } label: {
                                CreateButton()
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .background(Rectangle().fill(.listBackground).ignoresSafeArea())
            .toolbar {
                
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Subscriptions")
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .font(.subheadline)
                            .frame(minWidth: 95)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.listItemBackground)
                }
            }
        }
    }
    
    func calculateOutGoings() -> String {
        var total: Double = 0.0
        for subscription in subscriptions where subscription.type == "Expenditure" {
            switch subscription.repeatFrequency {
            case "Weekly":
                total += subscription.amount * 4
            case "Yearly":
                total += subscription.amount / 12
            case "Monthly":
                total += subscription.amount
            default:
                break
            }
        }
        
        return String("Out - \(total.formatted(.currency(code: Locale.current.currency?.identifier ?? "GBP")))")
    }

    func calculateInGoings() -> String {
        var total: Double = 0.0
        for subscription in subscriptions where subscription.type == "Income" {
            switch subscription.repeatFrequency {
            case "Weekly":
                total += subscription.amount * 4
            case "Yearly":
                total += subscription.amount / 12
            case "Monthly":
                total += subscription.amount
            default:
                break
            }
        }
        
        return String("In - \(total.formatted(.currency(code: Locale.current.currency?.identifier ?? "GBP")))")
    }
}

#Preview {
    SubscriptionsView()
}
