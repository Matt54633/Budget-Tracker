//
//  BackgroundTaskManager.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 21/05/2024.
//

import Foundation
import SwiftUI
import SwiftData
import BackgroundTasks
import AppIntents
import UIKit

class BackgroundTaskManager: ObservableObject {
    let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    func createSubscriptionTransactions() {
        DispatchQueue.main.async {
            let currentDate = Date()
            let currentDay = Calendar.current.component(.day, from: currentDate)
            let currentWeekday = Calendar.current.component(.weekday, from: currentDate)
            let currentMonth = Calendar.current.component(.month, from: currentDate)
            
            
            let fetch = FetchDescriptor<Subscription>()
            var subscriptions: [Subscription] = []
            
            do {
                subscriptions = try self.container.mainContext.fetch(fetch)
            } catch {
                print("Failed to fetch subscriptions: \(error)")
                return
            }
            
            for subscription in subscriptions {
                let shouldCreateTransaction: Bool
                
                switch subscription.repeatFrequency {
                case "Weekly":
                    shouldCreateTransaction = currentWeekday == subscription.date
                case "Monthly":
                    shouldCreateTransaction = currentDay == subscription.date
                case "Yearly":
                    shouldCreateTransaction = currentDay == subscription.date && currentMonth == Calendar.current.component(.month, from: subscription.lastTransactionDate ?? Date())
                default:
                    shouldCreateTransaction = false
                }
                
                if shouldCreateTransaction {
                    // Check if the subscription's lastTransactionDate is nil or not in the current period
                    if subscription.lastTransactionDate == nil ||
                        (subscription.lastTransactionDate != nil && !Calendar.current.isDate(subscription.lastTransactionDate!, equalTo: currentDate, toGranularity: .month)) {
                        
                        let transaction = Transaction(
                            title: subscription.title,
                            amount: subscription.amount,
                            date: currentDate,
                            category: subscription.category ?? Category(title: "", color: ""),
                            subscriptionTitle: subscription.title,
                            type: subscription.type
                        )
                        
                        self.container.mainContext.insert(transaction)
                        subscription.lastTransactionDate = currentDate
                    }
                }
            }
            
            do {
                try self.container.mainContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
            
            self.scheduleDailyTask()
        }
    }
    
    func scheduleDailyTask() {
        let request = BGAppRefreshTaskRequest(identifier: "subscriptionUpdate")
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))
        let next1AM = Calendar.current.date(byAdding: .hour, value: 1, to: nextMidnight!)
        request.earliestBeginDate = next1AM
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled")
        } catch {
            print("Could not schedule task: \(error)")
        }
    }
    
//    func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        
//        content.title = "Budgets"
//        content.body = "New subscription transaction created."
//        
//        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//        dateComponents.hour = 8
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Could not schedule notification: \(error)")
//            }
//        }
//    }
}
