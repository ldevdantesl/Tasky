//
//  TodoListFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 25.09.2024.
//

import SwiftUI

struct TodoListFragmentView: View {
    @EnvironmentObject var todoVM: TodoViewModel
    
    let todos: [Todo]
    let tapAction: ((Todo) -> ())?
    let doubleTapAction: ((Todo) -> ())?
    let noFoundImage: String
    let noFoundColor: Color
    let noFoundTitle: LocalizedStringKey
    let noFoundSubtitle: LocalizedStringKey
    let noFoundAction: (() -> ())?
    
    init(todos: [Todo], tapAction: ((Todo) -> ())? = nil, doubleTapAction: ((Todo) -> ())? = nil, noFoundImage: String, noFoundColor: Color, noFoundTitle: LocalizedStringKey, noFoundSubtitle: LocalizedStringKey, noFoundAction: (() -> Void)? = nil) {
        self.todos = todos
        self.tapAction = tapAction
        self.doubleTapAction = doubleTapAction
        self.noFoundImage = noFoundImage
        self.noFoundColor = noFoundColor
        self.noFoundTitle = noFoundTitle
        self.noFoundSubtitle = noFoundSubtitle
        self.noFoundAction = noFoundAction
    }
    
    var body: some View {
        if !todos.isEmpty {
            LazyVStack{
                ForEach(todos, id: \.id) { todo in
                    TodoRowView(todo: todo)
                        .onTapGesture(count: 2) {
                            guard let action = doubleTapAction else { return }
                            action(todo)
                        }
                        .onTapGesture {
                            guard let action = tapAction else { return }
                            action(todo)
                        }
                }
            }
            .padding(.top, 5)
        } else {
            NoFoundComponentView(image: noFoundImage, color: noFoundColor, title: noFoundTitle, subtitle: noFoundSubtitle, action: noFoundAction)
                .frame(maxWidth: .infinity)
                .padding(.top, Constants.screenHeight / 6)
                .padding(.horizontal, 15)
        }
    }
}

#Preview {
    TodoListFragmentView(todos: [], noFoundImage: "archivebox", noFoundColor: .blue, noFoundTitle: "No archive todos", noFoundSubtitle: "Add archived todos for archiving.", noFoundAction: nil)
}
