//
//  SubscriptionFormView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 19/05/2024.
//

import SwiftUI
import SwiftData
import WidgetKit

struct SubscriptionFormView: View {
    @Query private var categories: [Category]
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var subscriptionTitle: String = ""
    @State var subscriptionAmount: Double?
    @State var subscriptionCategory: Category = Category(title: "", color: "")
    @State var subscriptionDate: Int = 1
    @State var subscriptionType = "Expenditure"
    @State private var showAlert = false
    @State var repeatFrequency = "Weekly"
    @FocusState private var isAmountFieldFocused: Bool
    @FocusState private var isTitleFieldFocused: Bool
    
    var subscription: Subscription?
    var editFlag: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Title", text: $subscriptionTitle)
                    .fontWeight(.semibold)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .focused($isTitleFieldFocused)
                    .onAppear {
                        if !editFlag {
                            isTitleFieldFocused = true
                        }
                    }
                    .toolbar {
                        if isTitleFieldFocused {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Next") {
                                    isAmountFieldFocused = true
                                }
                                .font(.body)
                                .fontDesign(.default)
                                .fontWeight(.regular)
                            }
                        }
                    }
                
                TextField("0.00", value: $subscriptionAmount, format: .number)
                    .multilineTextAlignment(.trailing)
                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 0))
                    .foregroundStyle(customColorMappings[subscriptionCategory.color] ?? .blue)
                    .keyboardType(.decimalPad)
                    .focused($isAmountFieldFocused)
                    .overlay(alignment: .leading) {
                        Text(Locale.current.currencySymbol ?? "£")
                            .foregroundStyle( customColorMappings[subscriptionCategory.color] ?? .blue)
                    }
                    .toolbar {
                        if isAmountFieldFocused {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isAmountFieldFocused = false
                                }
                                .font(.body)
                                .fontDesign(.default)
                                .fontWeight(.regular)
                            }
                        }
                    }
                    .font(.system(size: 50))
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                
                Picker("Category", selection: $subscriptionCategory) {
                    ForEach(categories.sorted(by: { $0.isDefault && !$1.isDefault }), id: \.self) { category in
                        Label(category.title, systemImage: "star").tag(category)
                            .lineLimit(1)
                            .labelStyle(.titleOnly)
                    }
                }
                .pickerStyle(.menu)
                .tint(customColorMappings[subscriptionCategory.color] ?? .blue)
                .onAppear {
                    if !editFlag {
                        if let category = categories.first(where: { $0.isDefault }) {
                            subscriptionCategory = category
                        } else {
                            if let firstCategory = categories.first {
                                subscriptionCategory = firstCategory
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Picker("Payment Date", selection: $subscriptionDate) {
                    ForEach(1..<32) { day in
                        Text(getOrdinal(of: day)).tag(day)
                    }
                }
                .pickerStyle(.menu)
                .tint(customColorMappings[subscriptionCategory.color] ?? .blue)
                
                Picker(selection: $repeatFrequency, label: Text("Frequency")) {
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                    Text("Yearly").tag("Yearly")
                }
                .pickerStyle(.menu)
                .tint(customColorMappings[subscriptionCategory.color] ?? .blue)
                
                Picker("Type", selection: $subscriptionType) {
                    Text("Expenditure").tag("Expenditure")
                    Text("Income").tag("Income")
                }
                .pickerStyle(.menu)
                .tint(customColorMappings[subscriptionCategory.color] ?? .blue)
                
            }
            .listRowSpacing(12)
            .padding(.top, -20)
            .overlay(alignment: .bottom) {
                HStack(spacing: 10) {
                    
                    if editFlag {
                        Button {
                            showAlert = true
                        } label: {
                            Text("Delete")
                                .padding(7.5)
                                .frame(maxWidth: .infinity)
                        }
                        .fontWeight(.semibold)
                        .disabled(subscriptionTitle.isEmpty)
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("Are you sure you want to delete this subscription?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    if let subscription = subscription {
                                        context.delete(subscription)
                                    }
                                    
                                    dismiss()
                                    WidgetCenter.shared.reloadAllTimelines()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    
                    Button {
                        if editFlag {
                            if let subscription = subscription {
                                subscription.title = subscriptionTitle
                                if let amount = subscriptionAmount {
                                    subscription.amount = amount
                                }
                                subscription.date = subscriptionDate
                                subscription.category = subscriptionCategory
                                subscription.repeatFrequency = repeatFrequency
                                subscription.type = subscriptionType
                                
                            }
                        } else {
                            if let amount = subscriptionAmount {
                                let subscription = Subscription(title: subscriptionTitle, amount: amount, date: subscriptionDate, category: subscriptionCategory, repeatFrequency: repeatFrequency, type: subscriptionType)
                                
                                context.insert(subscription)
                            }
                        }
                        
                        dismiss()
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Text("Save")
                            .padding(7.5)
                            .frame(maxWidth: .infinity)
                    }
                    .fontWeight(.semibold)
                    .disabled(subscriptionTitle.isEmpty || subscriptionAmount == nil)
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                .padding(.bottom, 5)
                .padding(.horizontal)
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
    SubscriptionFormView()
}
