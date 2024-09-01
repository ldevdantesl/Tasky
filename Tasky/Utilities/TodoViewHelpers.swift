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
    
    func formatDate() -> String {
        if let date = todo.dueDate {
            let calendar = Calendar.current
            
            // Get the current date without time component
            let today = calendar.startOfDay(for: Date())

            // Create dates representing yesterday and tomorrow
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else {
                return "No Due Date"
            }
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"

            // Check if the date is today
            if calendar.isDate(date, inSameDayAs: today) {
                return "Today \(timeFormatter.string(from: date).capitalized)"
            }
            // Check if the date is yesterday
            else if calendar.isDate(date, inSameDayAs: yesterday) {
                return "Yesterday \(timeFormatter.string(from: date).capitalized)"
            }
            // Check if the date is tomorrow
            else if calendar.isDate(date, inSameDayAs: tomorrow) {
                return "Tomorrow \(timeFormatter.string(from: date).capitalized)"
            } else {
                // If not today, yesterday, or tomorrow, format the date as usual
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM h:mm a"
                return formatter.string(from: date).capitalized
            }
        } else {
            return "No due date"
        }
    }
}
