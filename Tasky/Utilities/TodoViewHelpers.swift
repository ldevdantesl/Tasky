//
//  Constants-ViewHelpers.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 20.08.2024.
//

import Foundation
import SwiftUI

struct TodoViewHelpers {
    enum ListStyles{
        case boxed
        case standard
    }
    
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
    
    var formatDate: String {
        if let date = todo.dueDate {
            return String(localized: "\(date.getDayDigit) of \(date.getDayMonthString)")
        } else {
            return "No due date"
        }
    }
}
