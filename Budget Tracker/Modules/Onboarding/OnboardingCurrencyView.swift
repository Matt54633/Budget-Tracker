//
//  OnboardingCurrencyView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI

struct OnboardingCurrencyView: View {
    @State private var currency: String = "GBP"
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("Add your currency!")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .foregroundStyle(.pink)
                .multilineTextAlignment(.center)
            
            Picker("Currency", selection: $currency) {
                Label("GBP", systemImage: "sterlingsign.circle").tag("GBP")
                Label("USD", systemImage: "dollarsign.circle").tag("USD")
                Label("EUR", systemImage: "eurosign.circle").tag("EUR")
                Label("JPY", systemImage: "yensign.circle").tag("JPY")
                Label("CAD", systemImage: "dollarsign.circle").tag("CAD")
                Label("CHF", systemImage: "francsign.circle").tag("CHF")
                Label("CNY", systemImage: "yensign.circle").tag("CNY")
                Label("NZD", systemImage: "dollarsign.circle").tag("NZD")
                
            }
            
            .tint(.pink)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .background(RoundedRectangle(cornerRadius: 10).fill(.thickMaterial))
            .onChange(of: currency) {
                UserDefaults.standard.set(currency, forKey: "Currency")
            }
            
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
            .disabled(currency.isEmpty)
            .tint(.pink)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
    }
}

#Preview {
    OnboardingCurrencyView()
}
