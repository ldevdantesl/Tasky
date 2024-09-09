//
//  SplashScreen.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 28.08.2024.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var animate: Double = 0
    var body: some View {
        ZStack{
            Color.background
                .ignoresSafeArea()
            
            Image("TaskIcon")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200, maxHeight: 200)
                .opacity(animate)
                .animation(.easeInOut, value: animate)
        }
        .onAppear{
            withAnimation {
                animate = 1
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
