//
//  AllTagsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct AllTagsFragmentView: View {
    @ObservedObject var todo: Todo
    
    var todosTags: [Tag] {
        todo.tags?.allObjects as? [Tag] ?? []
    }
    var body: some View {
        VStack(alignment:.leading){
            Text("Tags:")
                .font(.system(.callout, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            if let tags = todo.tags, tags.count > 0{
                ScrollView(.horizontal){
                    LazyHStack{
                        ForEach(todosTags, id: \.id) { tag in
                            Text("#\(tag.name ?? "")")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(foregroundForTagColor(tag: tag))
                                .padding(10)
                                .background(Tag.getColor(from: tag) ?? .gray.opacity(0.3), in:.capsule)
                                
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .scrollIndicators(.hidden)
                .frame(height: 50)
            } else {
                Text("No tags for this todo")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
                    .padding(.horizontal)
            }
        }
    }
    
    func foregroundForTagColor(tag: Tag) -> Color {
        if areColorsEqual(color1: Tag.getColor(from: tag), color2: .gray.opacity(0.3)){
            return .black
        } else {
            return .white
        }
    }
}

#Preview {
    AllTagsFragmentView(todo: TodoViewModel.mockToDo())
}
