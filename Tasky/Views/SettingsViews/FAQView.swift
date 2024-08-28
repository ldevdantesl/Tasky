//
//  FAQView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 27.08.2024.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        Form{
            Section{
                Button("ldevdantesl@gmail.com", action: openEmailApp)
            } footer: {
                Text("This is my private email. If you have any questions regarding the app. Please get in touch with me.")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
