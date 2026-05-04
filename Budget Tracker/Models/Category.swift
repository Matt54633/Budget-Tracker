//
//  Category.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import Foundation
import SwiftData

@Model
final class Category: Identifiable {
    var id: String = ""
    var title: String = ""
    var color: String = ""
    var transactions: [Transaction]?
    var subscriptions: [Subscription]?
    var incomes: [Income]?
    var isDefault: Bool = false
    
    init(title: String, color: String) {
        self.id = id
        self.title = title
        self.color = color
    }
}
