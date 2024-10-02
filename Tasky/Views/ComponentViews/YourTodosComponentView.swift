//
//  YourTasksComponentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct YourTodosComponentView: View {
    @State var isShowingActive: Bool = true
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var tagVM: TagViewModel
    @EnvironmentObject var settingsMgrVM: SettingsManagerViewModel
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }

    var body: some View {
        VStack{
            YourTodosHeaderView(isShowingActive: $isShowingActive, colorTheme: colorTheme)
                .padding(.horizontal, 5)
            TodoListView(isShowingActive: $isShowingActive)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    YourTodosComponentView()
}
