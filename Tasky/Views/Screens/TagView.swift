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
    
    init(tag: Tag) {
        self._tag = ObservedObject(wrappedValue: tag)
    }
    
    var todos: [Todo]{
        tag.todos?.allObjects as? [Todo] ?? []
    }
    
    var body: some View {
        ScrollView{
            TodoListFragmentView(todos: todos, tapAction: onTapAction, noFoundImage: "number.square.fill", noFoundColor: Tag.getColor(from: tag) ?? .blue, noFoundTitle: "No todos found", noFoundSubtitle: "No todos attached to this tag.\nAttach this tag to any to see it here")
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
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.horizontal, 15)
            .padding(.bottom, 5)
            .background(Tag.getColor(from: tag) ?? .blue)
        }
    }
    func onTapAction(todo: Todo){
        navPath.path.append(todo)
    }
}

#Preview {
    TagView(tag: TagViewModel.mockTags()[0])
}
