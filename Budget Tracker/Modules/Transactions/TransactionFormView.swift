//
//  TransactionFormView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TransactionFormView: View {
    @Query private var categories: [Category]
    @Query private var transactions: [Transaction]
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State var transactionTitle: String = ""
    @State var transactionAmount: Double?
    @State var transactionDate: Date = Date()
    @State var transactionCategory: Category = Category(title: "", color: "")
    @State var transactionType: String = "Expenditure"
    @State private var showAlert = false
    @FocusState private var isAmountFieldFocused: Bool
    @FocusState private var isTitleFieldFocused: Bool
    @State private var showSuggestions = false
    @State private var currentSuggestion: String = ""
    @State private var userIsTyping = false
    
    let dateFormatter = DateFormatter()
    var transaction: Transaction?
    var editFlag: Bool = false
    
    var filteredTransactionTitles: [String] {
        let trimmedInput = transactionTitle.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let uniqueTitles = Array(Set(transactions.map { $0.title.trimmingCharacters(in: .whitespacesAndNewlines) }))
        return uniqueTitles.filter { $0.lowercased().contains(trimmedInput) && !trimmedInput.isEmpty }
    }
    
    var body: some View {
        NavigationStack {
            List {
                TextField("Title", text: $transactionTitle, onEditingChanged: { isEditing in
                    userIsTyping = isEditing
                    if isEditing {
                        showSuggestions = true
                    } else {
                        showSuggestions = false
                    }
                }, onCommit: {
                    showSuggestions = false
                })
                .fontWeight(.semibold)
                .font(.title3)
                .fontDesign(.rounded)
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .focused($isTitleFieldFocused)
                .disabled(transaction?.subscriptionTitle != nil)
                .onAppear {
                    if !editFlag {
                        isTitleFieldFocused = true
                    }
                }
                .onChange(of: transactionTitle) {
                    if userIsTyping {
                        showSuggestions = true
                        if let suggestion = filteredTransactionTitles.first {
                            currentSuggestion = suggestion
                        } else {
                            currentSuggestion = ""
                        }
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
                
                if showSuggestions && !filteredTransactionTitles.isEmpty {
                    ForEach(filteredTransactionTitles, id: \.self) { title in
                        Button {
                            transactionTitle = title
                            isTitleFieldFocused = false
                            showSuggestions = false
                            currentSuggestion = ""
                            userIsTyping = false
                        } label: {
                            HStack {
                                Text(title)
                                    .fontDesign(.rounded)
                                    .fontWeight(.semibold)
                                Spacer()
                                
                                Image(systemName: "arrow.right.to.line.circle")
                                    .foregroundStyle(.cyan)
                            }
                        }
                        .tint(.primary)
                    }
                } else {
                    Group {
                        TextField("0.00", value: $transactionAmount, format: .number)
                            .multilineTextAlignment(.trailing)
                            .padding(EdgeInsets(top: 0, leading: 60, bottom: 0, trailing: 0))
                            .foregroundStyle(customColorMappings[transactionCategory.color] ?? .blue)
                            .keyboardType(.decimalPad)
                            .focused($isAmountFieldFocused)
                            .overlay(alignment: .leading) {
                                Text(Locale.current.currencySymbol ?? "£")
                                    .foregroundStyle(customColorMappings[transactionCategory.color] ?? .blue)
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
                            .disabled(transaction?.subscriptionTitle != nil)
                            .font(.system(size: 50))
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        
                        if let _ = transaction?.subscriptionTitle {
                            
                            HStack {
                                Text("Category")
                                Spacer()
                                if let title = transaction?.category?.title {
                                    Text(title)
                                        .foregroundStyle(customColorMappings[transactionCategory.color] ?? .blue)
                                }
                            }
                        } else {
                            
                            Picker("Category", selection: $transactionCategory) {
                                ForEach(categories.sorted(by: { $0.isDefault && !$1.isDefault }), id: \.self) { category in
                                    Label(category.title, systemImage: "star").tag(category)
                                        .lineLimit(1)
                                        .labelStyle(.titleOnly)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(customColorMappings[transactionCategory.color] ?? .blue)
                            .onAppear {
                                if !editFlag {
                                    if let category = categories.first(where: { $0.isDefault }) {
                                        transactionCategory = category
                                    } else {
                                        if let firstCategory = categories.first {
                                            transactionCategory = firstCategory
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if let subscriptionTitle = transaction?.subscriptionTitle {
                            HStack {
                                Text("Subscription")
                                
                                Spacer()
                                
                                Text(subscriptionTitle)
                                    .foregroundStyle(customColorMappings[transactionCategory.color] ?? .blue)
                            }
                        } else {
                            HStack() {
                                Text("Date")
                                
                                Spacer()
                                
                                Text(transactionDate.toString("dd MMM yyyy"))
                                    .foregroundStyle(customColorMappings[transactionCategory.color] ?? .blue)
                                    .overlay {
                                        DatePicker(
                                            "",
                                            selection: $transactionDate,
                                            displayedComponents: .date
                                        )
                                        .tint(customColorMappings[transactionCategory.color] ?? .blue)
                                        .blendMode(.destinationOver)
                                    }
                                    .padding(.horizontal,12)
                                    .padding(.vertical,7.5)
                                    .background(RoundedRectangle(cornerRadius: 7).fill(.thinMaterial))
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 9.5))
                                
                            }
                            .padding(.leading)
                            .padding(.vertical, 10)
                            .listRowInsets(EdgeInsets())
                        }
                        
                        
                        if let _ = transaction?.subscriptionTitle {
                            
                            HStack {
                                Text("Type")
                                Spacer()
                                if let type = transaction?.type {
                                    Text(type)
                                        .foregroundStyle(customColorMappings[transactionCategory.color] ?? .blue)
                                }
                            }
                        }
                        else {
                            Picker("Type", selection: $transactionType) {
                                Text("Expenditure").tag("Expenditure")
                                Text("Income").tag("Income")
                            }
                            .pickerStyle(.menu)
                            .tint(customColorMappings[transactionCategory.color] ?? .blue)
                        }
                    }
                }
            }
            .padding(.top, -20)
            .listRowSpacing(12)
            .overlay(alignment: .bottom) {
                if !showSuggestions {
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
                            .disabled(transactionTitle.isEmpty)
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Warning"),
                                    message: Text("Are you sure you want to delete this transaction?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        if let transaction = transaction {
                                            context.delete(transaction)
                                        }
                                        
                                        WidgetCenter.shared.reloadAllTimelines()
                                        dismiss()
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                        
                        if transaction?.subscriptionTitle == nil {
                            
                            Button {
                                if editFlag {
                                    if let transaction = transaction {
                                        transaction.title = transactionTitle
                                        if let amount = transactionAmount {
                                            transaction.amount = amount
                                        }
                                        transaction.date = transactionDate
                                        transaction.category = transactionCategory
                                        transaction.type = transactionType
                                    }
                                } else {
                                    if let amount = transactionAmount {
                                        let transaction = Transaction(title: transactionTitle, amount: amount, date: transactionDate, category: transactionCategory, type: transactionType)
                                        
                                        context.insert(transaction)
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
                            .disabled(transactionTitle.isEmpty || transactionAmount == nil)
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        }
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    TransactionFormView(transaction: nil)
}
