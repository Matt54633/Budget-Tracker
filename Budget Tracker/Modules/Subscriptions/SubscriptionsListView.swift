//
//  SubscriptionsListView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 21/05/2024.
//

import SwiftUI
import SwiftData

struct SubscriptionsListView: View {
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) var context
    @State var subscriptionToDelete: Subscription?
    @State var showAlert: Bool = false
    
    var body: some View {
        List {
            ForEach(subscriptions.sorted(by: { $0.date < $1.date }), id: \.self) { subscription in
                SubscriptionListItemView(subscription: subscription)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                    .swipeActions {
                        Button("Delete") {
                            subscriptionToDelete = subscription
                            showAlert = true
                        }
                        .tint(.red)
                    }
                
            }
            

        }
        .padding(.top, -20)
        .listRowSpacing(12)
        .tint(.primary)
        
        
        
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text("Are you sure you want to delete this subscription?"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        if let subscription = subscriptionToDelete {
                            context.delete(subscription)
                        }
                        
                    },
                    secondaryButton: .cancel()
                )
            }
    }
    
   
}

#Preview {
    SubscriptionsListView()
}
