//
//  CategorySpendBarView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 09/05/2024.
//

import SwiftUI
import SwiftData

struct CategorySpendBarView: View {
    @Query private var budgets: [Budget]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Binding var transactionType: String
    var category: Category
    var totalSpend: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(category.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(totalSpend, format: .currency(code: Locale.current.currency?.identifier ?? "GBP"))
                    .fontDesign(.rounded)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
            }
            GeometryReader { geometry in
                if let budget = budgets.first {
                    
                    let trackWidth = geometry.size.width
                    let trackX = trackWidth * CGFloat(totalSpend / budget.amount)
                    
                    Capsule()
                        .frame(width: trackWidth, height: 12)
                        .foregroundStyle(.gray.opacity(0.14))
                    
                    Capsule()
                        .frame(width: trackWidth, height: 12)
                        .foregroundStyle(customColorMappings[category.color] ?? .blue)
                        .mask(
                            HStack {
                                Rectangle()
                                    .frame(width: trackX)
                                Spacer()
                            }
                        )
                }
            }
        }
    }
}
