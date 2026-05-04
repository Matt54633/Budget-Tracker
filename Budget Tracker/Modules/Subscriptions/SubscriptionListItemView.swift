//
//  SubscriptionListItemView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 19/05/2024.
//

import SwiftUI

struct SubscriptionListItemView: View {
    var subscription: Subscription
    
    var body: some View {
        NavigationLink {
            SubscriptionFormView(subscriptionTitle: subscription.title, subscriptionAmount: subscription.amount, subscriptionCategory: subscription.category ?? Category(title: "", color: ""), subscriptionDate: subscription.date, subscriptionType: subscription.type, repeatFrequency: subscription.repeatFrequency, subscription: subscription, editFlag: true)
        } label: {
            HStack {
                Rectangle()
                    .fill(customColorMappings[subscription.category?.color ?? "blue"] ?? .blue)
                    .frame(width: 10)
                
                VStack(alignment: .leading) {
                    Text(subscription.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("Repeats \(subscription.repeatFrequency.lowercased()) on the \(getOrdinal(of: subscription.date))")
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
                .padding(.leading, 7.5)
                .padding(.vertical, 7.5)
                
                Spacer()
                
                Group {
                    Text(subscription.type == "Expenditure" ? "- " : "+ ") + Text(subscription.amount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .padding(.trailing, 7.5)
            }
        }
    }
    
    func getOrdinal(of number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

#Preview {
    SubscriptionListItemView(subscription: Subscription(title: "", amount: 0, date: 0, category: Category(title: "", color: ""), repeatFrequency: "Daily", type: "Expenditure"))
}
