//
//  TopCategorySpendView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 13/05/2024.
//

import SwiftUI
import SwiftData

struct TopCategorySpendView: View {
    @Query private var categories: [Category]
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("Top Categories")
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .fontWeight(.semibold)
                
            }
            .padding([.top])
            
            VStack {
//                ForEach(categories.sorted(by: { $0.transactions?.reduce(0, { $0 + $1.amount }) ?? 0 > $1.transactions?.reduce(0, { $0 + $1.amount }) ?? 0 }).prefix(3), id: \.self) { category in
//                    CategorySpendBarView(selectedMonth: $selectedMonth, selectedYear: $selectedYear, transactionType: .constant("Expenditure"), category: category)
//                }
            }
            
        }
        .frame(maxWidth: .infinity)
        
    }
}

#Preview {
    TopCategorySpendView(selectedMonth: .constant(5), selectedYear: .constant(2024))
}
