//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by Matt Sullivan on 28/05/2024.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        PieTransactionsWidgets()
        BarTransactionsWidgets()
        RecentTransactionsWidgets()
        CategorySpendWidgets()
    }
}
