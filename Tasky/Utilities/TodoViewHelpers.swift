//
//  Constants-ViewHelpers.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 20.08.2024.
//

import Foundation
import SwiftUI

struct TodoViewHelpers {
    var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    var priorityColor: Color {
        switch todo.priority {
        case 1:
            return .green
        case 2:
            return .blue
        default:
            return .red
        }
    }
    
    var priorityName: String {
        switch todo.priority {
        case 1:
            return "Trivial"
        case 2:
            return "Fair"
        default:
            return "Principal"
        }
    }
    
    var statusName: String {
        todo.isDone ? "Done" : "Undone"
    }
    
    var statusColor: Color {
        todo.isDone ? .green : .secondary
    }
    
    func formatDate() -> String {
        if let date = todo.dueDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, HH:mm"
            return formatter.string(from: date)
        } else {
            return "Due date is not specified"
        }
    }
}
