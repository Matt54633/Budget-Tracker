//
//  Income.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/09/2024.
//

import Foundation
import SwiftData

@Model
final class Income: Identifiable {
    var id: String = ""
    var title: String = ""
    var amount: Double = 0.0
    var date: Int = 0
    var category: Category?
    var repeatFrequency: String = ""
    var lastTransactionDate: Date?

    init(title: String, amount: Double, date: Int, category: Category, repeatFrequency: String) {
        self.id = UUID().uuidString
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
        self.repeatFrequency = repeatFrequency
    }
}
