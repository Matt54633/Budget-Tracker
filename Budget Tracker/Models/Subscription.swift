//
//  Subscription.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 19/05/2024.
//

import Foundation
import SwiftData

@Model
final class Subscription: Identifiable {
    var id: String = ""
    var title: String = ""
    var amount: Double = 0.0
    var date: Int = 0
    var category: Category?
    var repeatFrequency: String = ""
    var lastTransactionDate: Date?
    var type: String = "Expenditure"

    init(title: String, amount: Double, date: Int, category: Category, repeatFrequency: String, type: String) {
        self.id = UUID().uuidString
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.repeatFrequency = repeatFrequency
        self.type = type
    }
}
