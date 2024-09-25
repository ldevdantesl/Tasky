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
    let placeholder: LocalizedStringKey
    let maxChars: Int?
    var body: some View {
        ZStack(alignment:.trailing){
            TextField(placeholder, text: $text)
                .frame(maxWidth: Constants.screenWidth - 20)
                .autocorrectionDisabled()
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
                    .opacity(text.count > 5 ? 1 : 0)
                    .animation(.snappy, value: text)
            }
        }
    }
}

#Preview {
    TextFieldComponent(text: .constant(""), placeholder: "Title", maxChars: 40)
}

