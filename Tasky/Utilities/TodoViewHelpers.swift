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
}
