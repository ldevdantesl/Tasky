//
//  YourTodosHeaderView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 25.09.2024.
//

import SwiftUI

struct YourTodosHeaderView: View {
    @Binding var isShowingActive: Bool
    let colorTheme: Color
    
    var body: some View {
        HStack{
            Text("\(String(localized: isShowingActive ? "Active" : "Done"))")
                .font(.system(.title, design: .rounded, weight: .bold))
                
            Spacer()
            Button{
                withAnimation {
                    isShowingActive = true
                }
            } label:{
                Capsule()
                    .stroke(colorTheme, lineWidth: 2)
                    .background(isShowingActive ? colorTheme : .clear, in: .capsule)
                    .frame(width: 80, height: 40)
                    .overlay{
                        Text("Active")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(isShowingActive ? .white : colorTheme)
                            .frame(width: 80, height: 40)
                    }
            }
            Button{
                withAnimation {
                    isShowingActive = false
                }
            } label:{
                Capsule()
                    .stroke(colorTheme, lineWidth: 2)
                    .background(!isShowingActive ? colorTheme : .clear, in: .capsule)
                    .frame(width: 80, height: 40)
                    .overlay{
                        Text("Done")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(!isShowingActive ? .white : colorTheme)
                            .frame(width: 80, height: 40)
                    }
            }
        }
    }
}

#Preview {
    YourTodosHeaderView(isShowingActive: .constant(true), colorTheme: .blue)
}
