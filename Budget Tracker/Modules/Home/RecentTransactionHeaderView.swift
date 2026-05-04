//
//  RecentTransactionHeaderView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/09/2024.
//

import SwiftUI

struct RecentTransactionHeaderView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var displaySheet: Bool
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .textCase(.none)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                .fontDesign(.rounded)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
                .background(Capsule().fill(.listItemBackground))
                .padding(EdgeInsets(top: 0, leading: -15, bottom: 8, trailing: 0))
            
            
            Spacer()
            
            Button {
                displaySheet.toggle()
            } label: {
                ZStack {
                    
                    Circle()
                        .fill(.cyan.opacity(0.2))
                        .frame(width: 27, height: 27)
                    
                    Image(systemName: "plus")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.cyan)
                    
                }
                .padding(.trailing, -15)
            }
        }
        
    }
}

#Preview {
    RecentTransactionHeaderView(displaySheet: .constant(false), title: "Hello")
}
