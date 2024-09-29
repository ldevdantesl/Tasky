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
                CapsuleWeekStackComponent(settingsManagerVM: settingsMgrVM, showingWholeMonth: $showingWholeMonth, selectedMonth: $selectedMonth)
                
                Divider()
                    .padding(.horizontal, 10)
                
                if !showingWholeMonth {
                    YourTodosComponentView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    topBarLeadingHeading()
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    topBarTrailingButtons()
                }
            }
            .safeAreaInset(edge: .bottom){
                TabBarsComponent(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM:tagVM, path: $path)
                    .frame(height: 60)
                    .padding(.top, 10)
                    .background(Color.background.opacity(0.9))
            }
            .background(Constants.backgroundColor)
            .navigationDestination(for: String.self) { view in
                switch view{
                    case "SettingsView":
                        SettingsView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                    
                    case "TagSettingsView":
                        TagSettingsView(tagVM: tagVM, settingsManagerVM: settingsMgrVM, path: $path)
                            
                    case "DataStorageSettingsView":
                        DataAndStorageView(settingsManagerVM: settingsMgrVM, todoVM: todoVM, path: $path)
                            
                    case "ArchivedTodosView":
                        ArchivedTodosView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, path: $path)
                            
                    case "RemovedTodosView":
                        RemovedTodosView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, path: $path)
                    
                    case "SavedTodosView":
                        SavedTodosView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, path: $path)
                            
                    case "NotificationSoundSettingsView":
                        NotificationAndSoundsView(settingsMgrVM: settingsMgrVM, path: $path)
                            
                    case "PrivacySecuritySettingsView":
                        PrivacySecuritySettingsView(settingsMgrVM: settingsMgrVM, path: $path)
                            
                    case "AppearanceSettingsView":
                        AppearanceSettingsView(settingsManagerVM: settingsMgrVM, path:$path)
                            
                    default:
                        AddTodoView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                            .toolbar(.hidden, for: .navigationBar)
                }
            }
            .navigationDestination(for: Todo.self) { todo in
                TodoDetailView(observedTodo: todo, todoVM: todoVM, tagVM: tagVM, settingsManagerVM: settingsMgrVM, path: $path)
            }
            .scrollIndicators(.hidden)
        }
    }
    @ViewBuilder
    func topBarLeadingHeading() -> some View {
        if !showingWholeMonth {
            Text("\(calendar.currentDay.getWeekName.capitalized), \(calendar.currentDay.getDayDigit) \(String(calendar.currentDay.getDayMonthString.prefix(3)))")
                .font(.system(.title, design: .rounded, weight: .bold))
                
        } else {
            Menu{
                ForEach(Date.getEveryMonths(startingFrom: Date().getDayMonthInt, locale: settingsMgrVM.currentLanguage), id:\.self) { date in
                    Button(action: {selectedMonth = date.getDayMonthString}){
                        Text("\(date.getDayMonthString) \(Date.now.getYear != date.getYear ? date.getYear : "")")
                    }
                }
            } label: {
                HStack{
                    Text("\(selectedMonth.capitalized)")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    Image(systemName: "chevron.up.chevron.down")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                }
            }
        }
    }
    
    @ViewBuilder
    func topBarTrailingButtons() -> some View {
        if calendar.currentDay.getDayAndMonth != Date.now.getDayAndMonth && !showingWholeMonth{
            Image(systemName: "sun.max.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 20)
                .foregroundStyle(colorTheme)
                .onTapGesture {
                    withAnimation {
                        calendar.returnToToday()
                        selectedMonth = calendar.currentDay.getDayMonthString
                    }
                }
                .padding(.trailing, 10)
        }
        Image(systemName: showingWholeMonth ? "xmark.circle.fill" : "calendar")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 20)
            .foregroundStyle(colorTheme)
            .onTapGesture {
                withAnimation(.bouncy) {
                    showingWholeMonth.toggle()
                }
            }
    }
}

#Preview {
    NavigationStack{
        TodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
