//
//  TagsForTodo.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 27.08.2024.
//

import SwiftUI

struct TagsForTodoView: View {
    @State var todo: Todo
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    
    var tagsArray: [Tag] = []
    
    init(todo: Todo, settingsManagerVM: SettingsManagerViewModel) {
        self.todo = todo
        self.settingsManagerVM = settingsManagerVM
        self.tagsArray = todo.tags?.allObjects as? [Tag] ?? []
    }
    
    var body: some View {
        if !tagsArray.isEmpty{
            HStack{
                ForEach(tagsArray, id:\.hashValue) { tag in
                    Text("#\(tag.name ?? "")")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .padding(3)
                        .background(Tag.getColor(from: tag) ?? .gray.opacity(0.3), in:.capsule)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: Constants.screenWidth - 40, maxHeight: 15, alignment:.leading)
        }
    }
}

#Preview {
    TagsForTodoView(todo: Todo(context: PersistentController.shared.context), settingsManagerVM: MockPreviews.viewModel)
}
