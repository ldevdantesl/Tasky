//
//  YourTasksComponentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct YourTodosComponentView: View {
    @State var isShowingActive: Bool = true
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    @Binding var path: NavigationPath
    var body: some View {
        VStack{
            YourTodosHeaderView(isShowingActive: $isShowingActive, colorTheme: colorTheme)
            TodoListView(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM: tagVM, path: $path, isShowingActive: $isShowingActive)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    YourTodosComponentView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
}
