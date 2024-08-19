//
//  ContentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            TodoView()
                .tabItem { Label("Tasks", systemImage: "tray.full") }
            Text("Settings")
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    MainView()
}
