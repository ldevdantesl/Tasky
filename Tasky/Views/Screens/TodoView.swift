//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @ObservedObject var calendar = CalendarSet.instance
    
    @State private var showingWholeMonth: Bool = false
    @State private var selectedMonth: String = CalendarSet.instance.currentDay.getDayMonthString
    
    @State private var path: NavigationPath = NavigationPath()
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        NavigationStack(path: $path){
            ScrollView{
                TodoHeaderView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, showingWholeMonth: $showingWholeMonth, selectedMonth: $selectedMonth)
                    .padding(.horizontal,10)
                CapsuleWeekStackComponent(settingsManagerVM: settingsMgrVM, showingWholeMonth: $showingWholeMonth, selectedMonth: $selectedMonth)
                
                if !showingWholeMonth{
                    YourTodosComponentView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                        .padding(.horizontal, 10)
                }
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    TabBarsComponent(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM:tagVM, path: $path)
                        .padding(.top, 10)
                }
            }
            .background(Constants.backgroundColor)
            .navigationDestination(for: String.self) { view in
                switch view{
                    case "SettingsView":
                        SettingsView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                    case "TagSettingsView":
                        TagSettingsView(tagVM: tagVM, settingsManagerVM: settingsMgrVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                    case "DataStorageSettingsView":
                        DataAndStorageView(settingsManagerVM: settingsMgrVM, todoVM: todoVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                    case "ArchivedTodosView":
                        ArchivedTodosView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                    case "RemovedTodosView":
                        RemovedTodosView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                    case "NotificationSoundSettingsView":
                        NotificationAndSoundsView(settingsMgrVM: settingsMgrVM)
                            .toolbar(.hidden, for: .navigationBar)
                    case "PrivacySecuritySettingsView":
                        PrivacySecuritySettingsView(settingsMgrVM: settingsMgrVM)
                            .toolbar(.hidden, for: .navigationBar)
                    case "AppearanceSettingsView":
                        AppearanceView(settingsManagerVM: settingsMgrVM)
                            .toolbar(.hidden, for: .navigationBar)
                    default:
                        AddTodoView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    NavigationStack{
        TodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
