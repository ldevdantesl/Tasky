//
//  TodoViewModel.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import Foundation
import CoreData
import SwiftUI

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var sortDescriptor: NSSortDescriptor?
    
    static let shared = TodoViewModel()
    
    let context = PersistentController.shared.context
    
    init() {
        fetchTodos()
    }
    
    func createTodo(title: String, description: String?, priority: Int16){
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.desc = description
        newTodo.priority = priority
        newTodo.addedOn = .now
        
        saveContext()
        
    }
    
    func fetchTodos(){
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        if let sortDescriptor{
            request.sortDescriptors = [sortDescriptor]
        } else { request.sortDescriptors = []}
        do {
            todos = try context.fetch(request)
        } catch {
            print("Error fetching todos: \(error.localizedDescription)")
        }
    }
    
    func editTodos(_ todo: Todo, newTitle: String, newDesc: String?, newIsDone: Bool, newPriority: Int16){
        todo.title = newTitle
        todo.desc = newDesc
        todo.isDone = newIsDone
        todo.priority = newPriority
        
        saveContext()
    }
    
    func toggleCompletion(_ todo: Todo){
        todo.isDone.toggle()
        saveContext()
    }
    
    func deleteTodo(_ todo: Todo){
        context.delete(todo)
        saveContext()
    }
    
    func deleteTodoByIndex(at offsets: IndexSet){
        offsets.forEach { index in
            let todo = todos[index]
            context.delete(todo)
        }
        saveContext()
    }
    
    func deleteAllTodos(){
        let request: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            log("Error deleting all todos: \(error.localizedDescription)")
        }
    }
    
    private func saveContext(){
        PersistentController.shared.saveContext()
        fetchTodos()
    }
    
}

#if DEBUG
extension TodoViewModel{
    static func mockToDo() -> Todo{
        let mocktodo = Todo(context: PersistentController.shared.context)
        mocktodo.id = UUID()
        mocktodo.title = "Make a coffee"
        mocktodo.desc = "Make a cofee for my friend which comes tomorrow"
        mocktodo.priority = 2
        
        return mocktodo
    }
}
#endif
