//
//  AuthenticateUserView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 24.08.2024.
//

import SwiftUI
import LocalAuthentication

struct AuthenticateUserFragmentView: View {
    @Environment(\.colorScheme) var colorScheme
    let settingsManagerViewModel: SettingsManagerViewModel
    @Binding var isAuthenticated: Bool
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: "lock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: Constants.screenWidth / 5)
                .foregroundStyle(.green, .gray.quaternary)
            Text("Tasky Locked")
                .font(.system(.title, design: .rounded, weight: .bold))
            
            Text("Unlock with Face ID to open Tasky")
            Spacer()
            
            Text("Use Face ID")
                .foregroundStyle(colorScheme == .light ? .white : .black)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .frame(maxWidth: Constants.screenWidth - 40, maxHeight: 40)
                .background(Color.green, in:.capsule)
                .onTapGesture(perform: authenticate)
        }
        .scrollIndicators(.hidden)
        .scrollDisabled(true)
        .padding(20)
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        guard settingsManagerViewModel.settingsManager.privacyAndSecurityManager.useBiometrics else { return }
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            let reason = "Tasky requires your passkey for authentication"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                if success{
                    isAuthenticated = false
                } else {
                    if let authError = authError {
                        print("Authentication failed: \(authError.localizedDescription)")
                    }
                }
            }
        } else {
            if let error{
                print("User's phone is not compatible with Face ID or Touch ID: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AuthenticateUserFragmentView(settingsManagerViewModel: MockPreviews.viewModel, isAuthenticated: .constant(false))
}
