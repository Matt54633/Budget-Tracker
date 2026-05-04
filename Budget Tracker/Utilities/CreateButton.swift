//
//  CreateButton.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct CreateButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(.cyan)
                .frame(width: 28, height: 28)
            
            Image(systemName: "plus")
                .font(.caption)
                    .fontWeight(.bold)
                .foregroundStyle(colorScheme == .dark ? .black : .white)
            
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    CreateButton()
}
