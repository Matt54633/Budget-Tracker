//
//  Budget.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import Foundation
import SwiftData

@Model
final class Budget: Identifiable {
    var id: String = ""
    var amount: Double = 0.0
    
    init(amount: Double) {
        self.id = UUID().uuidString
        self.amount = amount
    }
}
