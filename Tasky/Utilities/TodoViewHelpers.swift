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
    
    var priorityName: LocalizedStringKey {
        switch todo.priority {
        case 1:
            return "trivial_key"
        case 2:
            return "fair_key"
        default:
            return "principal_key"
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
