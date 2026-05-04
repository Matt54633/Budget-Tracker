//
//  String Extensions.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 13/05/2024.
//

import Foundation

extension String {
    func pluralize(count: Int) -> String {
        return count == 1 ? self : self + "s"
    }
}
