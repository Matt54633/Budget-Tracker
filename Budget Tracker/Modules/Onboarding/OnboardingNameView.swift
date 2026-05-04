//
//  OnboardingNameView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI

struct OnboardingNameView: View {
    @State private var name: String = ""
    @FocusState private var isNameFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("Lets get to know each other!")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
                .multilineTextAlignment(.center)
            
            TextField("Your Name", text: $name)
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .font(.title3)
                .frame(height: 40)
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                .background(RoundedRectangle(cornerRadius: 10).fill(.thickMaterial))
                .onChange(of: name) {
                    UserDefaults.standard.set(name, forKey: "Name")
                }
                .onAppear {
                    isNameFieldFocused = true
                }
                .focused($isNameFieldFocused)
            
            
            Spacer()
            
            NavigationLink {
                OnboardingBudgetView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                Text("Next")
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .disabled(name.isEmpty)
            .tint(.cyan)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
}

#Preview {
    OnboardingNameView()
}
