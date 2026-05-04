//
//  MonthYear.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 13/05/2024.
//

import Foundation

struct MonthYear: Hashable, Comparable {
    let month: Int
    let year: Int

    static func < (lhs: MonthYear, rhs: MonthYear) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else {
            return lhs.month < rhs.month
        }
    }
}
