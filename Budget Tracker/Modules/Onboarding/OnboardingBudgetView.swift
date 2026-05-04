//
//  OnboardingBudgetView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI
import SwiftData

struct OnboardingBudgetView: View {
    @Query private var budgets: [Budget]
    @Query private var categories: [Category]
    @Environment(\.modelContext) var context
    @State var budgetAmount: Double?
    @FocusState private var isBudgetFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("Lets set a monthly budget!")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
                .multilineTextAlignment(.center)
            
            TextField("0", value: $budgetAmount, format: .number)
                .font(.system(size: 64))
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
                .padding(EdgeInsets(top: 10, leading: 60, bottom: 10, trailing: 15))
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .background(RoundedRectangle(cornerRadius: 10).fill(.thickMaterial))
                .overlay(alignment: .leading) {
                    Text(Locale.current.currencySymbol ?? "£")
                        .font(.system(size: 64))
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundStyle(.cyan)
                        .padding(.leading, 15)
                }
                .padding(.top, 5)
                .onAppear {
                    if let existingBudget = budgets.first {
                        budgetAmount = existingBudget.amount
                    }
                    
                    isBudgetFieldFocused = true
                }
                .focused($isBudgetFieldFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isBudgetFieldFocused = false
                        }
                        .font(.body)
                        .fontDesign(.default)
                        .fontWeight(.regular)
                    }
                }
            
            Spacer()
            
            NavigationLink {
                OnboardingNotificationView()
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        if let budgetAmount = budgetAmount {
                            if budgets.isEmpty {
                                context.insert(Budget(amount: budgetAmount))
                            } else {
                                if let existingBudget = budgets.first {
                                    existingBudget.amount = budgetAmount
                                }
                            }
                        }
                        
                        if categories.count == 0 {
                            let titles = ["Accomodation", "Groceries", "Clothing", "Apple Pay"]
                            let colours = ["orange", "blue", "green", "yellow"]
                            
                            for (title, colour) in zip(titles, colours) {
                                context.insert(Category(title: title, color: colour))
                            }
                        }
                        
                    }
            } label: {
                Text("Next")
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .tint(.cyan)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
}

#Preview {
    OnboardingBudgetView()
}
