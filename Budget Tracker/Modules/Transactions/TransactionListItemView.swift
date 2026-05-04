//
//  TransactionListItemView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct TransactionListItemView: View {
    @Environment(\.colorScheme) var colorScheme
    var transaction: Transaction
    
    var body: some View {
        
        NavigationLink {
            TransactionFormView(transactionTitle: transaction.title, transactionAmount: transaction.amount, transactionDate: transaction.date, transactionCategory: transaction.category ?? Category(title: "", color: ""), transactionType: transaction.type, transaction: transaction, editFlag: true)
        } label: {
            if let category = transaction.category {
                HStack {
                    Rectangle()
                        .fill(customColorMappings[category.color] ?? .blue)
                        .frame(width: 10)
                    
                    VStack(alignment: .leading) {
                        Text(transaction.title)
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .lineLimit(1)
                            .padding(.leading, 7.5)
                     
                        Text(transaction.date.formatted(date: .numeric, time: .omitted))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .padding(.leading, 7.5)
                    }
                    .padding(.vertical, 7.5)
                    
                    Spacer()
                    
                    Group {
                        Text(transaction.type == "Expenditure" ? "- " : "+ ") + Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                    }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .padding(.trailing, 7.5)
                    
                }
            }
        }
    }
}

#Preview {
    TransactionListItemView(transaction: Transaction(title: "Rent", amount: 20.57, date: Date(), category: Category(title: "Groceries", color: "blue"), type: "Expenditure"))
}
