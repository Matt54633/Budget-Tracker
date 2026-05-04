//
//  TotalHeaderView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 18/05/2024.
//

import SwiftUI

struct TotalHeaderView: View {
    var title: String
    
    var body: some View {
            
            
            Text(title)
                .textCase(.none)
                .font(.caption)
                .fontDesign(.rounded)
                .foregroundStyle(.gray)
                .fontWeight(.semibold)
                .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
                .background(Capsule().fill(.listItemBackground).frame(height: 30))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing:0))

        
    }
}

#Preview {
    TransactionHeaderView(title: "Today")
}
