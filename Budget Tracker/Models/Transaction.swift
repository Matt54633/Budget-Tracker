//
//  Transaction.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import Foundation
import SwiftData

@Model
final class Transaction: Identifiable {
    var id: String = ""
    var title: String = ""
    var amount: Double = 0.0
    var date: Date = Date()
    var category: Category?
    var subscriptionTitle: String?
    var type: String = "Expenditure"
    
    init(title: String, amount: Double, date: Date, category: Category, subscriptionTitle: String? = nil, type: String) {
        self.id = UUID().uuidString
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.subscriptionTitle = subscriptionTitle
        self.type = type
    }
}
