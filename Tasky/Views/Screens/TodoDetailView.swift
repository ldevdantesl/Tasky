//
//  TodoDetailView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct TodoDetailView: View {
    let todo: Todo
    @Environment(\.dismiss) var dismiss
    
    var priorityColor: Color{
        switch todo.priority{
        case 1:
            return .green
        case 2:
            return .blue
        default:
            return .red
        }
    }
    
    var priorityName: String{
        switch todo.priority{
        case 1:
            return "Trivial"
        case 2:
            return "Fair"
        default:
            return "Principal"
        }
    }
    
    var body: some View {
        VStack(spacing:20){
            HStack{
                Text("To-Do")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                Image(systemName: "flag.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 25)
                    .frame(maxHeight: 25)
                    .foregroundStyle(priorityColor)
                Spacer()
            
                Button(role:.destructive, action:{}) {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 25)
                        .frame(maxHeight: 25)
                }
            }
            showTodo(text: "Title", bindText: todo.title)
            
            showTodo(text: "Description", bindText: todo.desc)
            
            showPriority()
            
            Spacer()
            
            Button(action:{dismiss()}) {
                Text("Done")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: Constants.screenWidth - 20)
                    .frame(maxHeight: 50)
                    .background(Color.blue, in:.capsule)
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func showTodo(text: String, bindText: String?) -> some View {
        HStack{
            VStack(alignment:.leading){
                Text(text)
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                
                Text(bindText ?? "No Description")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .frame(maxWidth: Constants.screenWidth - 10, alignment: .leading)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func showPriority() -> some View {
        HStack{
            VStack(alignment:.leading){
                Text("Priority")
                    .font(.system(.callout, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                HStack{
                    Text(priorityName)
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: Constants.screenWidth / 3 - 20)
                .frame(maxHeight: 40)
                .background(priorityColor, in:.capsule)
            }
            Spacer()
        }
    }
}

#Preview {
    TodoDetailView(todo: TodoViewModel.mockToDo())
}
