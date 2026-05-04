//
//  TransactionHeaderView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct TransactionHeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    
    var body: some View {
        Text(title)
            .textCase(.none)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
            .fontDesign(.rounded)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
            .background(Capsule().fill(.listItemBackground))
            .padding(EdgeInsets(top: 0, leading: -15, bottom: 8, trailing: 0))
        
    }
}

#Preview {
    TransactionHeaderView(title: "Today")
}
