//
//  TodoViewModelTests.swift
//  TaskyTests
//
//  Created by Buzurg Rakhimzoda on 19.09.2024.
//

import Testing
import OSLog
@testable import Tasky

@MainActor
struct TodoViewModelTests {
    let viewModel = TodoViewModel()
    
    @Test func addTodo() async throws {
        let title = "Make a coffee"
        let description = "Coffee is good"
        
        let todo = try await viewModel.createTodo(title: title, description: description, priority: 1, dueDate: .now, tags: [])
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.todayTodos.count > 0)
        viewModel.deleteTodo(todo)
    }
    
    @Test func deleteTodo() async throws {
        viewModel.deleteAllTodos()
        let title = "Make a coffee"
        let description = "Coffee is good"
        let todo = try await viewModel.createTodo(title: title, description: description, priority: 1, dueDate: .now, tags: [])
        viewModel.deleteTodo(todo)
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.todayTodos.count == 0)
    }
    
    @Test func editTodo() async throws {
        viewModel.deleteAllTodos()
        logger.log("Total todos: \(viewModel.todayTodos.count)")
        let title = "Make a coffee"
        let description = "Coffee is good"
        
        let todo = try await viewModel.createTodo(title: title, description: description, priority: 1, dueDate: .now, tags: [])
        logger.log("Total todos: \(viewModel.todayTodos.count)")
        
        let editedTitle = "Make a tea"
        let editedDescription = "Tea is better"
        let editedPriority: Int16 = 2
        
        try viewModel.editTodos(todo, newTitle: editedTitle, newDesc: editedDescription, newPriority: editedPriority)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.todayTodos[0].title == editedTitle)
        #expect(viewModel.todayTodos[0].priority == editedPriority)
        #expect(viewModel.todayTodos[0].desc == editedDescription.capitalized)
        
        viewModel.deleteTodo(todo)
    }
}
