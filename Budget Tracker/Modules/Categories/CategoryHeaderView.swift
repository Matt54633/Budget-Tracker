//
//  CategoryHeaderView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct CategoryHeaderView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CategoryHeaderView(title: "Groceries")
}
