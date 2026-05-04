//
//  WeekYear.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 13/05/2024.
//

import Foundation
import SwiftUI

struct WeekYear: Hashable, Comparable {
    let week: Int
    let year: Int
    
    var startOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = week
        components.yearForWeekOfYear = year
        components.weekday = 2 
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek) ?? Date()
    }
    
    static func < (lhs: WeekYear, rhs: WeekYear) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else {
            return lhs.week < rhs.week
        }
    }
}
