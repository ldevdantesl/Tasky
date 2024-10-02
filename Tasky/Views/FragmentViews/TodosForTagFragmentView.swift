//
//  TodosForTagFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 11.09.2024.
//

import SwiftUI

struct TodosForTagFragmentView: View {
    @ObservedObject var todoVM: TodoViewModel
    @Environment(\.dismiss) var dismiss
    
    let tag: Tag
    
    var todos: [Todo] {
        tag.todos?.allObjects as? [Todo] ?? []
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                TodoListFragmentView(todoVM: todoVM, todos: todos, noFoundImage: "number.square.fill", noFoundColor: .blue, noFoundTitle: "No todos found", noFoundSubtitle: "No todos attached to this tag.\nAttach this tag to any to see it here")
            }
            .scrollIndicators(.hidden)
            .navigationTitle(tag.name ?? "Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel", systemImage: "xmark.circle.fill") {
                        dismiss()
                    }
                    .tint(.gray)
                }
            }
        }
    }
}

#Preview {
    TodosForTagFragmentView(todoVM: TodoViewModel(), tag: TagViewModel.mockTags()[0])
}
