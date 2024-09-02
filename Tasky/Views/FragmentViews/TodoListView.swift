//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    
    @AppStorage("isBoxStyle") var isBoxStyle: Bool = true
    @Binding var path: NavigationPath
    
    @State private var searchText: String = ""
    @State private var isShowingDone: Bool = false
    
    let columns:[GridItem] = [GridItem(.fixed(Constants.screenWidth / 2 - 20)), GridItem(.fixed(Constants.screenWidth / 2 - 20))]
    
    var filteredTodos: [Todo]{
        if searchText.isEmpty{
            return todoVM.todos.filter { $0.isDone == false }
        } else {
            return todoVM.todos.filter { todo in
               todo.title!.localizedStandardContains(searchText)
            }
        }
    }
    
    var doneTodos: [Todo]{
        return todoVM.todos.filter { $0.isDone }
    }
    
    var body: some View {
        Group{
            if todoVM.todos.isEmpty, #available(iOS 17.0, *) {
                ContentUnavailableView("No todos yet", systemImage: "questionmark.folder", description: Text("Add todos to get started"))
            } else if filteredTodos.isEmpty, #available(iOS 17.0, *){
                ContentUnavailableView("No results for '\(searchText)'", systemImage: "questionmark.folder", description: Text("Check the spellin  or try a new search."))
            } else {
                if !isBoxStyle{
                    List{
                        ForEach(filteredTodos, id: \.self){ todo in
                            NavigationLink(value: todo) {
                                TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                            }
                        }
                        .onDelete(perform: todoVM.deleteTodoByIndex)
                        if doneTodos.isEmpty == false {
                            Button{
                                withAnimation {
                                    isShowingDone.toggle()
                                }
                            } label: {
                                HStack{
                                    Image(systemName: isShowingDone ? "eye" : "eye.slash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 15)
                                    Text(isShowingDone ? "Hide Completed" : "Show Completed")
                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        if isShowingDone {
                            ForEach(doneTodos, id: \.self){ todo in
                                NavigationLink(value: todo) {
                                    TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                                }
                            }
                            .onDelete(perform: todoVM.deleteTodoByIndex)
                        }
                    }
                } else {
                    ScrollView(.vertical){
                        ForEach(filteredTodos, id: \.self){ todo in
                            TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                                .onTapGesture {
                                    path.append(todo)
                                }
                        }
                        if doneTodos.isEmpty == false {
                            Button{
                                withAnimation {
                                    isShowingDone.toggle()
                                }
                            } label: {
                                HStack{
                                    Image(systemName: isShowingDone ? "eye" : "eye.slash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 15)
                                    Text(isShowingDone ? "Hide Completed" : "Show Completed")
                                        .font(.system(.caption, design: .rounded, weight: .semibold))
                                    Spacer()
                                }
                            }
                            .padding()
                            .padding(.horizontal, 10)
                        }
                        if isShowingDone {
                            ForEach(doneTodos, id: \.self){ todo in
                                TodoRowView(todo: todo, settingsManagerVM: settingsMgrVM, todoVM: todoVM)
                                    .onTapGesture {
                                        path.append(todo)
                                    }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .navigationDestination(for: Todo.self){ todo in
            TodoDetailView(observedTodo: todo, todoVM: todoVM, tagVM: tagVM, settingsManagerVM: settingsMgrVM)
        }
    }
}

#Preview {
    NavigationStack{
        TodoListView(settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel(), path: .constant(NavigationPath()))
    }
}
