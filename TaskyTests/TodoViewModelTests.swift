//
//  TodoViewModelTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 19.09.2024.
//

import Testing
import OSLog
@testable import Tasky

struct TodoViewModelTests {
    let viewModel = TodoViewModel()
    
    @Test func addTodo() throws {
        let title = "Make a coffee"
        let description = "Coffee is good"
        
        let todo = viewModel.createTodo(title: title, description: description, priority: 1, dueDate: .now, tags: [])
        #expect(viewModel.todayTodos.count > 0)
        viewModel.deleteTodo(todo)
    }
    
    @Test func deleteTodo() throws {
        viewModel.deleteAllTodos()
        let title = "Make a coffee"
        let description = "Coffee is good"
        
        let todo = viewModel.createTodo(title: title, description: description, priority: 1, dueDate: .now, tags: [])
        viewModel.deleteTodo(todo)
        #expect(viewModel.todayTodos.count == 0)
    }
    
    @Test func editTodo() throws {
        viewModel.deleteAllTodos()
        logger.log("Total todos: \(viewModel.todayTodos.count)")
        let title = "Make a coffee"
        let description = "Coffee is good"
        
        let todo = viewModel.createTodo(title: title, description: description, priority: 1, dueDate: .now, tags: [])
        logger.log("Total todos: \(viewModel.todayTodos.count)")
        
        let editedTitle = "Make a tea"
        let editedDescription = "Tea is better"
        let editedPriority: Int16 = 2
        
        viewModel.editTodos(todo, newTitle: editedTitle, newDesc: editedDescription, newPriority: editedPriority)
        
        logger.info("Todo title: \(todo.title ?? ""), description: \(todo.desc ?? ""), priority: \(todo.priority)")
        logger.info("Todo: \(todo)\n\(viewModel.todayTodos[0])")
        
        #expect(viewModel.todayTodos[0].title == editedTitle)
        #expect(viewModel.todayTodos[0].priority == editedPriority)
        #expect(viewModel.todayTodos[0].desc == editedDescription.capitalized)
        
        viewModel.deleteTodo(todo)
    }
}
