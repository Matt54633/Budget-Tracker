//
//  TransactionShortcut.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 17/05/2024.
//

import AppIntents
import SwiftUI
import SwiftData
import Foundation
import UIKit
import UserNotifications

struct TransactionShortcut: AppIntent {
    
    @Parameter(title: "Name")
    var name: String?
    
    @Parameter(title: "Amount")
    var amount: String?
    
    static let title: LocalizedStringResource = "Automate Apple Pay Transactions"
    
    @Dependency(key: "ModelContainer") private var modelContainer: ModelContainer
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = ModelContext(modelContainer)
        
        let fetch = FetchDescriptor<Category>()
        var categories: [Category] = []
        
        do {
            categories = try context.fetch(fetch)
        } catch {
            logError(error: error)
            return .result(dialog: "Failed to fetch categories")
        }
        

        let cleanedAmount = self.amount?.filter { "0123456789.".contains($0) }
        let merchantName = (self.name?.isEmpty ?? true) ? "No Merchant" : self.name!
        let amountDouble = Double(cleanedAmount ?? "") ?? 0
        
        if let applePay = categories.first(where: { $0.title == "Apple Pay" }) {
            context.insert(Transaction(title: merchantName, amount: amountDouble, date: Date(), category: applePay, type: "Expenditure"))
            
            do {
                try context.save()
            } catch {
                logError(error: error)
                return .result(dialog: "Failed to save transaction")
            }
        } else {
            let error = NSError(domain: "TransactionShortcut", code: 1, userInfo: [NSLocalizedDescriptionKey: "Apple Pay category not found"])
            logError(error: error)
            return .result(dialog: "Apple Pay category not found")
        }
        
        return .result(dialog: "Transaction Created")
    }
    
    private func logError(error: Error) {
        // Log the error to the console
        print("Error: \(error.localizedDescription)")
        
        // Send a local notification with the error details
        let content = UNMutableNotificationContent()
        content.title = "Budget Tracker Error"
        content.body = "An error occurred: \(error.localizedDescription)"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
