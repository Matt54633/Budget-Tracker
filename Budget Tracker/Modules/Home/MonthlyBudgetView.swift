//
//  MonthlyBudgetView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI

struct MonthlyBudgetView: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    var body: some View {
        VStack {
            BudgetPieView(selectedMonth: $selectedMonth, selectedYear: $selectedYear)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MonthlyBudgetView(selectedMonth: .constant(4), selectedYear: .constant(2024))
}
