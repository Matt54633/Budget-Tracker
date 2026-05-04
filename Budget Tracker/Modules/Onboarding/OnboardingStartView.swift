//
//  OnboardingStartView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI

struct OnboardingStartView: View {
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("Budgets")
                .font(.system(size: 72))
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
            
            Spacer()
            
            NavigationLink {
                OnboardingNameView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .tint(.cyan)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .tint(.cyan)
    }
}

#Preview {
    OnboardingStartView()
}
