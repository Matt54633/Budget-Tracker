//
//  ContentView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 07/05/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboardingComplete") var onboardingComplete: Bool?

    var body: some View {
        Group {
            if onboardingComplete == true {
                NavView()
            } else {
                OnboardingStartView()
            }
        }
    }
}

#Preview {
    ContentView()
}
