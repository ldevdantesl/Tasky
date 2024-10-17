//
//  TagView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.10.2024.
//

import SwiftUI

struct TagView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navPath: NavPathManager
    
    @ObservedObject var tag: Tag
    
    @State private var selectedTodo: Todo?
    
    init(tag: Tag) {
        self._tag = ObservedObject(wrappedValue: tag)
    }
    
    var todos: [Todo]{
        tag.todos?.allObjects as? [Todo] ?? []
    }
    
    var tagColor: Color {
        return Tag.getColor(from: tag) ?? .blue
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todos: todos, tapAction: onTapAction, noFoundImage: tag.systemImage ?? "number.square.fill", noFoundColor: Tag.getColor(from: tag) ?? .blue, noFoundTitle: "No todos found", noFoundSubtitle: "No todos attached to this tag.\nAttach this tag to any to see it here")
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .top) {
            UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomLeading: 25, bottomTrailing: 25))
                .fill(tagColor.gradient)
                .overlay(alignment:.bottom) {
                    HStack{
                        Text("#\(tag.name ?? "")")
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Tag.foregroundForTagColor(tag: tag))
                        Image(systemName: tag.systemImage ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Tag.foregroundForTagColor(tag: tag))
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
                .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 5)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .frame(height: 40)
        }
        .sheet(item: $selectedTodo) { todo in
            TodoDetailView(observedTodo: todo, isShowingBottomButtons: false)
                .padding(.top, 20)
                .presentationDragIndicator(.visible)
        }
    }
    func onTapAction(todo: Todo){
        selectedTodo = todo
    }
}

#Preview {
    TagView(tag: TagViewModel.mockTags()[0])
}
