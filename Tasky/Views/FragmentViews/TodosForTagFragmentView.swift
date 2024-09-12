//
//  TodosForTagFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 11.09.2024.
//

import SwiftUI

struct TodosForTagFragmentView: View {
    @Environment(\.dismiss) var dismiss
    
    let tag: Tag
    
    var todos: [Todo] {
        tag.todos?.allObjects as? [Todo] ?? []
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach(todos, id: \.self){ todo in
                    TodoRowView(todo: todo)
                }
            }
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
    TodosForTagFragmentView(tag: TagViewModel.mockTags()[0])
}
