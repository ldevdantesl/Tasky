//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @EnvironmentObject var todoVM: TodoViewModel
    @EnvironmentObject var tagVM: TagViewModel
    @EnvironmentObject var settingsMgrVM: SettingsManagerViewModel
    @EnvironmentObject var navpath: NavPathManager
    
    @ObservedObject var calendar = CalendarSet.instance
    
    @State private var showingWholeMonth: Bool = false
    @State private var selectedMonth: String = CalendarSet.instance.currentDay.getDayMonthString
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        NavigationStack(path: $navpath.path){
            ScrollView{
                CapsuleWeekStackComponent(showingWholeMonth: $showingWholeMonth, selectedMonth: $selectedMonth)
                
                Divider()
                    .padding(.horizontal, 10)
                
                if !showingWholeMonth {
                    YourTodosComponentView()
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
                TabBarsComponent()
                    .frame(height: 60)
                    .padding(.top, 10)
                    .background(Color.background.opacity(0.9))
            }
            .background(Constants.backgroundColor)
            .navigationDestination(for: String.self) { view in
                switch view{
                    case "SettingsView":
                        SettingsView()
                    
                    case "TagSettingsView":
                        TagSettingsView()
                            
                    case "DataStorageSettingsView":
                        DataAndStorageView()
                            
                    case "ArchivedTodosView":
                        ArchivedTodosView()
                            
                    case "RemovedTodosView":
                        RemovedTodosView()
                    
                    case "SavedTodosView":
                        SavedTodosView()
                            
                    case "NotificationSoundSettingsView":
                        NotificationAndSoundsView()
                            
                    case "PrivacySecuritySettingsView":
                        PrivacySecuritySettingsView()
                            
                    case "AppearanceSettingsView":
                        AppearanceSettingsView()
                            
                    default:
                        AddTodoView()
                            .toolbar(.hidden, for: .navigationBar)
                }
            }
            .navigationDestination(for: Todo.self){ todo in
                TodoDetailView(observedTodo: todo)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    func topBarLeadingHeading() -> some View {
        if !showingWholeMonth {
            Text("\(calendar.currentDay.getWeekName.capitalized), \(calendar.currentDay.getDayDigit) \(String(calendar.currentDay.getDayMonthString.prefix(3)))")
                .font(.system(size: 25, weight: .bold, design: .rounded))

        } else {
            Menu{
                ForEach(Date.getEveryMonths(startingFrom: Date().getDayMonthInt, locale: settingsMgrVM.currentLanguage), id:\.self) { date in
                    Button(action: { selectedMonth = date.getDayMonthString }){
                        Text("\(date.getDayMonthString) \(Date.now.getYear != date.getYear ? date.getYear : "")")
                    }
                }
            } label: {
                HStack{
                    Text("\(selectedMonth.capitalized)")
                        .font(.system(size: 25, weight: .bold, design: .rounded))
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
        TodoView()
    }
}
