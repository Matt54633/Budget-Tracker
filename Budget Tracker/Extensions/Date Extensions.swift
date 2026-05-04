//
//  Date Extensions.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 13/05/2024.
//

import Foundation

extension Date {
    var startOfWeek: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: dateComponents) ?? self
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek) ?? self
    }
    
    var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var ordinalDay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let day = Calendar.current.component(.day, from: self)
        return formatter.string(from: NSNumber(value: day)) ?? ""
    }
    
    func toString(_ format: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
