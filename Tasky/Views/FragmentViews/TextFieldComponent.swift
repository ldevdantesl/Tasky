//
//  TextFieldComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on
//

import SwiftUI

struct TextFieldComponent: View {
    @Binding var text: String
    @State private var oldText: String = ""
    let placeholder: String
    let maxChars: Int?
    var body: some View {
        ZStack(alignment:.trailing){
            TextField(placeholder, text: $text)
                .padding(10)
                .padding(.trailing, 50)
                .frame(height: 50)
                .frame(maxWidth: Constants.screenWidth - 20)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 0.4))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal,10)
                .onChange(of: text) { value in
                    if let maxChars = maxChars{
                        let previousValue = oldText
                        if text.count > maxChars{
                            self.text = previousValue
                        }
                    }
                    oldText = value
                }
            
            if let maxChars = maxChars{
                Text("\(text.count)/\(maxChars)")
                    .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    TextFieldComponent(text: .constant(""), placeholder: "Title", maxChars: 40)
}

