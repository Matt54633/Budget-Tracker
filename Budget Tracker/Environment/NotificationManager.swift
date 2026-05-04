//
//  NotificationManager.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus?
    private let notificationCenter: UNUserNotificationCenter
    private let notificationIdentifierKey = "NotificationIdentifier"
    
    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }
    
    func getAuthorizationStatus() {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.authorizationStatus = .authorized
                    
                    // Set default time to 6 PM if not already set
                    if UserDefaults.standard.object(forKey: "NotificationTime") == nil {
                        let calendar = Calendar.current
                        var components = DateComponents()
                        components.hour = 18
                        components.minute = 0
                        let defaultTime = calendar.date(from: components) ?? Date()
                        UserDefaults.standard.set(defaultTime, forKey: "NotificationTime")
                    }

                    // Set default frequency to daily if not already set
                    if UserDefaults.standard.string(forKey: "NotificationFrequency") == nil {
                        UserDefaults.standard.set("daily", forKey: "NotificationFrequency")
                    }
                    
                    // Schedule the notification daily at the default time
                    self?.scheduleNotification(interval: .day, at: 18, minute: 0)
                } else if let error = error {
                    print("Error: \(error)")
                    self?.authorizationStatus = .denied
                } else {
                    self?.authorizationStatus = .notDetermined
                }
            }
        }
    }
    
    func clearNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        UserDefaults.standard.removeObject(forKey: notificationIdentifierKey)
        
    }
    
    func getNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func scheduleNotification(interval: Calendar.Component, at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Budget Tracker"
        content.body = "It's time to add your transactions!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger: UNCalendarNotificationTrigger
        
        switch interval {
        case .day:
            trigger = UNCalendarNotificationTrigger.dailyTrigger(dateMatching: dateComponents, repeats: true)
        case .weekOfYear:
            trigger = UNCalendarNotificationTrigger.weeklyTrigger(dateMatching: dateComponents, repeats: true)
        case .month:
            trigger = UNCalendarNotificationTrigger.monthlyTrigger(dateMatching: dateComponents, repeats: true)
        default:
            return
        }
        
        // Remove existing notification with the same identifier before scheduling a new one
        if let existingIdentifier = UserDefaults.standard.string(forKey: notificationIdentifierKey) {
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [existingIdentifier])
        }
        
        // Generate a new identifier
        let identifier = UUID().uuidString
        
        // Store the identifier in UserDefaults
        UserDefaults.standard.set(identifier, forKey: notificationIdentifierKey)
    
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}

extension UNCalendarNotificationTrigger {
    static func dailyTrigger(dateMatching dateComponents: DateComponents, repeats: Bool) -> UNCalendarNotificationTrigger {
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
    }
    
    static func weeklyTrigger(dateMatching dateComponents: DateComponents, repeats: Bool) -> UNCalendarNotificationTrigger {
        var components = dateComponents
        components.weekday = Calendar.current.component(.weekday, from: Date())
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
    }
    
    static func monthlyTrigger(dateMatching dateComponents: DateComponents, repeats: Bool) -> UNCalendarNotificationTrigger {
        var components = dateComponents
        components.day = Calendar.current.component(.day, from: Date())
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
    }
}
