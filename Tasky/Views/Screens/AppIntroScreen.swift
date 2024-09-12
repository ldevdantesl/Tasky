//
//  AppIntroScreen.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 11.09.2024.
//

import SwiftUI

struct AppIntroScreen: View {
    
    @AppStorage("isFirstEntry") var isFirstEntry: Bool = true
    
    let appIntroImages: [String] = ["AppIntro1", "AppIntro2", "AppIntro3"]
    let appIntroTexts: [String] = ["Catch Your Time", "Boost Productivity", "Stay Organized"]
    let appIntroSubtitles: [String] = [
        "Find balance with our powerful app",
        "Simplify tasks, boost productivity",
        "Reclaim control over your daily routine"
    ]
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack{
            TabView(selection: $selectedTab){
                ForEach(0..<3, id: \.self) { index in
                    VStack(spacing: 5){
                        Image(appIntroImages[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: Constants.screenWidth - 40, height: Constants.screenHeight / 1.7)
                        VStack(alignment:.leading){
                            Text(appIntroTexts[index])
                                .font(.system(.title, design: .rounded, weight: .bold))
                                .foregroundStyle(.primary)
                            
                            Text(appIntroSubtitles[index])
                                .font(.system(.subheadline, design: .rounded, weight: .light))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: Constants.screenWidth - 30, alignment:.leading)
                        .padding(.horizontal, 25)
                        Spacer()
                    }
                }
            }
            Button{
                withAnimation {
                    selectedTab < 2 ? selectedTab = selectedTab + 1 : isFirstEntry.toggle()
                }
            } label: {
                Text(selectedTab != 2 ? "Continue" : "Let's Organize")
                    .font(.system(.title2, design: .rounded, weight: .light))
                    .foregroundStyle(.white)
                    .frame(width: Constants.screenWidth - 40, height: 50, alignment: .center)
                    .background(Color.green, in:.capsule )
            }
            HStack{
                ForEach(0..<3, id:\.self) { ind in
                    Image(systemName: ind == selectedTab ? "circle.fill" : "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.green)
                }
            }
        }
        .background(Color.background)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    AppIntroScreen()
}
