//
//  Budget_TrackerApp.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData
import BackgroundTasks
import AppIntents

fileprivate let sharedModelContainer: ModelContainer = {
    do {
        let schema = Schema([Transaction.self, Budget.self, Category.self, Subscription.self])
        return try ModelContainer(
            for: schema,
            configurations: ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
        )
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@main
struct Budget_TrackerApp: App {
    
    init() {
        let asyncDependency: () async -> (ModelContainer) = { @MainActor in
            return sharedModelContainer
        }
        AppDependencyManager.shared.add(key: "ModelContainer", dependency: asyncDependency)
    }
    
    @Environment(\.scenePhase) private var phase
    @StateObject private var backgroundTaskManager = BackgroundTaskManager(container: sharedModelContainer)
    
//    var backgroundModelContainer: ModelContainer = {
//        do {
//            let schema = Schema([Transaction.self, Budget.self, Category.self, Subscription.self])
//            return try ModelContainer(
//                for: schema,
//                configurations: ModelConfiguration(
//                    schema: schema,
//                    isStoredInMemoryOnly: false
//                )
//            )
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: phase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                backgroundTaskManager.createSubscriptionTransactions()
            case .background:
                backgroundTaskManager.scheduleDailyTask()
            default:
                break
            }
        }
        
        .backgroundTask(.appRefresh("subscriptionUpdate")) {
            await backgroundTaskManager.scheduleDailyTask()
            await backgroundTaskManager.createSubscriptionTransactions()
        }
        
    }
}

