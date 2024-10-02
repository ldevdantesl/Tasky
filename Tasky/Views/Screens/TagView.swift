//
//  TagView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 1.10.2024.
//

import SwiftUI

struct TagView: View {
    @ObservedObject var tag: Tag
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var todoVM: TodoViewModel
    
    @State private var showEditing: Bool = false
    
    @Binding var path: NavigationPath
    
    init(tag: Tag, tagVM: TagViewModel, todoVM: TodoViewModel, settingsMgrVM: SettingsManagerViewModel, path: Binding<NavigationPath>) {
        self._tag = ObservedObject(wrappedValue: tag)
        self.tagVM = tagVM
        self.todoVM = todoVM
        self._path = path
    }
    
    var todos: [Todo]{
        tag.todos?.allObjects as? [Todo] ?? []
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todoVM: todoVM, todos: todos, tapAction: onTapAction, noFoundImage: "number.square.fill", noFoundColor: .blue, noFoundTitle: "No todos found", noFoundSubtitle: "No todos attached to this tag.\nAttach this tag to any to see it here")
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top) {
            HStack{
                Text("#\(tag.name ?? "")")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Tag.foregroundForTagColor(tag: tag))
                Image(systemName: tag.systemImage ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.white)
                Spacer()
                
                Button(action:{}){
                    Image(systemName: "trash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.bottom, 10)
            .padding(.horizontal, 15)
            .background(Tag.getColor(from: tag) ?? .blue)
        }
    }
    
    func onTapAction(todo: Todo) {
        path.append(todo)
    }
}

#Preview {
    NavigationStack{
        TagView(tag: TagViewModel.mockTags()[0], tagVM: TagViewModel(), todoVM: TodoViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
