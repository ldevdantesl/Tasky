//
//  TodoListView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 30.08.2024.
//

import SwiftUI

struct TodoRowView: View {
    @StateObject var todo: Todo
    
    var body: some View {
        ZStack(alignment:.topLeading){
            RoundedRectangle(cornerRadius: 25)
                .fill(TodoViewHelpers(todo: todo).priorityColor.gradient)
            
            VStack(alignment:.leading){
                HStack{
                    Text(todo.title ?? "Uknown title")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    if todo.isSaved {
                        Image(systemName: "bookmark.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                }
                Text(todo.desc ?? String(localized: "No Description"))
                    .font(.system(.subheadline, design: .rounded, weight: .regular))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                HStack {
                    if let tags = todo.tags?.allObjects as? [Tag]{
                        HStack(spacing: 5){
                            ForEach(tags, id:\.self) { tag in
                                Image(systemName: tag.systemImage ?? "")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    Spacer()
                    HStack(spacing: 0){
                        Text(TodoViewHelpers(todo: todo).formatDate)
                            .font(.system(.caption, design: .rounded, weight: .light))
                        if !todo.dueDate!.isStartOfDay{
                            Text(" at \(todo.dueDate!.getTime)")
                                .font(.system(.caption, design: .rounded, weight: .light))
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .padding([.top,.horizontal])
            .foregroundStyle(.white)
            
        }
        .frame(width: Constants.screenWidth - 20)
        .frame(minHeight: 130, maxHeight: 130)
    }
}

#Preview {
    TodoRowView(todo: TodoViewModel.mockToDo())
}
