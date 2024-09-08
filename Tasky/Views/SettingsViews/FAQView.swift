//
//  FAQView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 27.08.2024.
//

import SwiftUI

struct FAQView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("FAQ")
                    .font(.system(.title, design: .rounded, weight: .bold))
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.customSecondary)
                    .onTapGesture {
                        withAnimation {
                            dismiss()
                        }
                    }
            }
            .padding(.horizontal, 10)
            SettingsRowComponent(title: "ldevdantesl@gmail.com", image: "mail.fill", color: .green, action: openEmailApp)
            Text("This is my private email. If you have any questions regarding the app. Please get in touch with me.")
                .font(.system(.callout, design: .rounded, weight: .light))
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.backgroundColor)
    }
    
    func openEmailApp(){
        let email = "ldevdantesl@gmail.com"
        let subject = "Help Needed"
        let body = "Hi, I need help with ..."
        
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let emailURL = URL(string: "mailto: \(email)?subject=\(encodedSubject)&body=\(encodedBody)"){
            if UIApplication.shared.canOpenURL(emailURL){
                UIApplication.shared.open(emailURL)
            } else {
                print("Cannot open email.")
            }
        }
        
    }
}

#Preview {
    NavigationStack{
        FAQView()
    }
}
