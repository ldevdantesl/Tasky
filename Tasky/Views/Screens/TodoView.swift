//
//  TodoView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoView: View {
    @AppStorage("isBoxStyle") var isBoxStyle: Bool = false
    
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @State private var onAddTodo = false
    @State private var onAddTag = false
    @State private var searchText: String = ""
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            TodoListView(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM: tagVM, path: $path)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Picker("",selection: $isBoxStyle) {
                            Image(systemName: "list.bullet")
                                .tag(false)
                            Image(systemName: "square.stack")
                                .tag(true)
                            
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .contextMenu{
                            toolbarSortButton()
                        }
                    }
                    ToolbarItem(placement:.topBarLeading){
                        NavigationLink{
                            SettingsView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM)
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing){
                    Menu{
                        Button("Todo", action: { onAddTodo.toggle() })
                        Button("Tag", action: { onAddTag.toggle() })
                    } label:{
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white)
                            .frame(minWidth: 30, maxWidth: 40)
                            .frame(height: 30)
                            .padding(20)
                            .background(settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme, in:.circle)
                            .shadow(radius: 5)
                            .padding()
                    }
                }
                .fullScreenCover(isPresented: $onAddTodo) {
                    AddTodoView(todoVM: todoVM, tagVM: tagVM)
                }
                .sheet(isPresented: $onAddTag) {
                    AddingTagView(tagVM: tagVM)
                        .presentationDetents([.medium, .large])
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
