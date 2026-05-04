//
//  OnboardingNotificationView.swift
//  Budget Tracker
//
//  Created by Matt Sullivan on 08/05/2024.
//

import SwiftUI
import SWTools

struct OnboardingNotificationView: View {
    @StateObject var notificationManager = NotificationManager()
    @AppStorage("onboardingComplete") var onboardingComplete: Bool?
    @Environment(\.isOnMac) var isOnMac
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("Transaction Reminders")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .foregroundStyle(.cyan)
                .multilineTextAlignment(.center)
            
            Text("Budget tracker will remind you to add your transactions on your chosen schedule!")
                .multilineTextAlignment(.center)
                .padding(.top, 7.5)
            
            Spacer()
            
            Button {
                notificationManager.requestPermission()
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
            }
            .tint(.cyan)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .onTapGesture {
                if isOnMac {
                    onboardingComplete = true
                }
            }
            .onChange(of: notificationManager.authorizationStatus) {
                onboardingComplete = true
            }
            
        }
    }
}

#Preview {
    OnboardingNotificationView()
}
