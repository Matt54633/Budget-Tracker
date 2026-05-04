//
//  SettingsView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI
import SwiftData
import UserNotifications
import WidgetKit

struct SettingsView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Query private var categories: [Category]
    @Query private var budgets: [Budget]
    @StateObject var notificationManager = NotificationManager()
    @State private var scheduleNotifications: Bool = true
    @State private var name: String = ""
    @State private var budgetAmount: Double?
    @State private var time: Date = Date()
    @State private var frequency: String = "daily"
    @State private var defaultCategory: Category = Category(title: "", color: "")
    @FocusState private var focusField: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section("Profile") {
                    TextField("Name", text: $name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.vertical, 6)
                        .onChange(of: name) { oldName, newName in
                            UserDefaults.standard.set(newName, forKey: "Name")
                        }
                }
                
                Section("Budget") {
                    TextField("0", value: $budgetAmount, format: .number)
                        .font(.title2)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundStyle(.cyan)
                        .padding(EdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 15))
                        .multilineTextAlignment(.leading)
                        .keyboardType(.decimalPad)
                        .onTapGesture {
                            focusField = true
                        }
                        .focused($focusField)
                        .toolbar {
                            if focusField {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Done") {
                                        focusField = false
                                    }
                                }
                            }
                        }
                        .overlay(alignment: .leading) {
                            Text(Locale.current.currencySymbol ?? "£")
                                .font(.title2)
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                                .foregroundStyle(.cyan)
                        }
                        .onAppear {
                            if let budget = budgets.first {
                                budgetAmount = budget.amount
                            }
                        }
                        .onChange(of: budgetAmount) {
                            if let budget = budgets.first {
                                if let budgetAmount = budgetAmount {
                                    budget.amount = budgetAmount
                                    
                                    WidgetCenter.shared.reloadAllTimelines()
                                }
                            }
                        }
                }
                
                if categories.count > 0 {
                    Section("Categories") {
                        Picker("Default", selection: $defaultCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category.title).tag(category)
                            }
                        }
                        .padding(.vertical, 3)
                        .onChange(of: defaultCategory) {  oldCategory, newCategory in
                            newCategory.isDefault = true
                            oldCategory.isDefault = false
                        }
                        .onAppear {
                            if let defaultCat = categories.first(where: { $0.isDefault }) {
                                defaultCategory = defaultCat
                            }
                            notificationManager.getAuthorizationStatus()
                        }
                    }
                    
                }
                
                Section("Notifications") {
                    
                                        
                    if notificationManager.authorizationStatus == .authorized {
                        Toggle("Allow", isOn: $scheduleNotifications)
                            .onChange(of: scheduleNotifications) { oldValue, newValue in
                                
                                if newValue == false {
                                    notificationManager.clearNotifications()
                                } else {
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: time)
                                    let minute = calendar.component(.minute, from: time)
                                    let interval: Calendar.Component
                                    
                                    switch frequency {
                                    case "daily":
                                        interval = .day
                                    case "weekly":
                                        interval = .weekOfYear
                                    case "monthly":
                                        interval = .month
                                    default:
                                        return
                                    }
                                    
                                    notificationManager.scheduleNotification(interval: interval, at: hour, minute: minute)
                                }
                            }
                        
                        DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                            .padding(.vertical, 1)
                            .onChange(of: time) { oldTime, newTime in
                                UserDefaults.standard.set(newTime, forKey: "NotificationTime")
                                
                                if scheduleNotifications {
                                    
                                    
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: newTime)
                                    let minute = calendar.component(.minute, from: newTime)
                                    let interval: Calendar.Component
                                    
                                    switch frequency {
                                    case "daily":
                                        interval = .day
                                    case "weekly":
                                        interval = .weekOfYear
                                    case "monthly":
                                        interval = .month
                                    default:
                                        return
                                    }
                                    
                                    notificationManager.scheduleNotification(interval: interval, at: hour, minute: minute)
                                }
                            }
                        
                        HStack {
                            Text("Repeat")
                                .padding(.trailing)
                            
                            Picker("Frequency", selection: $frequency) {
                                Text("Daily").tag("daily")
                                Text("Weekly").tag("weekly")
                                Text("Monthly").tag("monthly")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: frequency) { oldFrequency, newFrequency in
                                UserDefaults.standard.set(newFrequency, forKey: "NotificationFrequency")
                                
                                if scheduleNotifications {
                                    
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: time)
                                    let minute = calendar.component(.minute, from: time)
                                    let interval: Calendar.Component
                                    
                                    switch newFrequency {
                                    case "daily":
                                        interval = .day
                                    case "weekly":
                                        interval = .weekOfYear
                                    case "monthly":
                                        interval = .month
                                    default:
                                        return
                                    }
                                    
                                    notificationManager.scheduleNotification(interval: interval, at: hour, minute: minute)
                                }
                            }
                        }
                        .padding(.vertical, 3)
                        
                    } else {
                        Text("Notifications must be enabled in Settings.")
                    }
                    
                    
                    
                    
                }
                
                
            }
            .onChange(of: scenePhase) {
                notificationManager.getAuthorizationStatus()
            }
            .listSectionSpacing(5)
            .toolbar {
                
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Settings")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .font(.subheadline)
                            .frame(minWidth: 95)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.listItemBackground)
                }
            }
            .onAppear {
                if let storedName = UserDefaults.standard.string(forKey: "Name") {
                    name = storedName
                }
                if let storedTime = UserDefaults.standard.object(forKey: "NotificationTime") as? Date {
                    time = storedTime
                }
                if let storedFrequency = UserDefaults.standard.string(forKey: "NotificationFrequency") {
                    frequency = storedFrequency
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Budget.self, Category.self, configurations: config)
    
    container.mainContext.insert(Budget(amount: 200))
    container.mainContext.insert(Category(title: "Groceries", color: "blue"))
    
    return SettingsView()
        .modelContainer(container)
}
