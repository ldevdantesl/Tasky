//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @Environment(\.colorScheme) var systemColorScheme
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @State private var onAddTodo = false
    @State private var onAddTag = false
    @State private var searchText: String = ""
    @State private var path: NavigationPath = NavigationPath()
    
    @ObservedObject var calendar = CalendarSet.instance
    
    var colorScheme: ColorScheme {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorScheme ?? systemColorScheme
    }
    
    var body: some View {
        NavigationStack(path: $path){
            VStack(alignment:.leading){
                HStack{
                    Text("\(calendar.currentDay.getWeekName.capitalized), \(calendar.currentDay.getDayDigit) \(String(calendar.currentDay.getDayMonth.prefix(3)))")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                }
                .padding(.horizontal,10)
                CapsuleWeekStackComponent(settingsManagerVM: settingsMgrVM)
                    .frame(height: 130)
                YourTodosComponentView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                    .padding(.horizontal,10)
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    TabBarsComponent(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM:tagVM, path: $path)
                        .padding(.top, 10)
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
