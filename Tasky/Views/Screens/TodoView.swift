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
    @State private var onAddTodo = false
    @State private var onAddTag = false
    @State private var searchText: String = ""
    @State private var selectedMonth: String = CalendarSet.instance.currentDay.getDayMonthString
    
    @State private var path: NavigationPath = NavigationPath()
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        NavigationStack(path: $path){
            VStack(alignment:.leading){
                TodoHeaderView(todoVM: todoVM, settingsMgrVM: settingsMgrVM, showingWholeMonth: $showingWholeMonth, selectedMonth: $selectedMonth)
                .padding(.horizontal,10)
                CapsuleWeekStackComponent(settingsManagerVM: settingsMgrVM, showingWholeMonth: $showingWholeMonth, selectedMonth: $selectedMonth)
                    
                if !showingWholeMonth{
                    YourTodosComponentView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                        .padding(.horizontal,10)
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
                if view == "SettingsView"{
                    SettingsView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                        .toolbar(.hidden, for: .navigationBar)
                } else {
                    AddTodoView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                }
            }
        }
    }
    
    func sortBy(sortKey: String, ascending: Bool){
        todoVM.sortDescriptor = NSSortDescriptor(key: sortKey, ascending: ascending)
    }
    
    func toolbarSortButton() -> some View{
        Menu{
            Button("Title", systemImage: "text.magnifyingglass",action: { sortBy(sortKey: "title", ascending: true) })
            Button("Time added", systemImage: "clock",action: { sortBy(sortKey: "addedOn", ascending: true) })
            Button("Due date", systemImage: "calendar", action: { sortBy(sortKey: "dueDate", ascending: true) })
            Menu("Priority", systemImage: "bookmark"){
                Button("Ascending", systemImage: "arrow.up.circle",action: { sortBy(sortKey: "priority", ascending: true) })
                Button("Decending", systemImage: "arrow.down.circle",action: { sortBy(sortKey: "priority", ascending: false) })
            }
        } label: {
            Label(
                title: { Text("Sort By") },
                icon: { Image(systemName: "list.bullet.indent") }
            )
        }
    }
}

#Preview {
    NavigationStack{
        TodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
    }
}
