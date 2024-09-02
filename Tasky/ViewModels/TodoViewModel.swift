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
    @Published var removedTodos: [Todo] = []
    @Published var archivedTodos: [Todo] = []
    @Published var sortDescriptor: NSSortDescriptor? {
        didSet {
            fetchAllTodos()
        }
    }
    
    let context = PersistentController.shared.context
    
    init() {
        fetchAllTodos()
    }
    
    func createTodo(title: String, description: String?, priority: Int16, dueDate: Date?, tags: [Tag]){
        let newTodo = Todo(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.desc = description
        newTodo.priority = priority
        newTodo.dueDate = dueDate
        newTodo.addedOn = .now
        newTodo.isDone = false
        newTodo.isArchived = false
        newTodo.isRemoved = false
        
        if !tags.isEmpty{
            newTodo.tags = NSSet(array: tags)
        }
        
        saveContext()
    }
    
    func fetchAllTodos(){
        fetchStandardTodos()
        fetchArchivedTodos()
        fetchRemovedTodos()
    }
    
    func fetchStandardTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        let archivePredicate = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let removedPredicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [archivePredicate, removedPredicate])
        
        if let sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            todos = try context.fetch(request)
        } catch {
            print("Error fetching removed Todos: \(error.localizedDescription)")
        }
    }
    
    func fetchRemovedTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: true))
        
        do {
            removedTodos = try context.fetch(request)
        } catch {
            print("Error fetching removed Todos: \(error.localizedDescription)")
        }
    }
    
    func fetchArchivedTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isArchived == %@", NSNumber(value: true))
        
        do {
            archivedTodos = try context.fetch(request)
        } catch {
            print("Error fetching removed Todos: \(error.localizedDescription)")
        }
    }
    
    func archive(_ todo: Todo) {
        todo.isArchived = true
        saveContext()
    }
    
    func unArchive(_ todo: Todo){
        todo.isArchived = false
        saveContext()
    }
    
    func unArchiveAll() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isArchived == %@", NSNumber(value: true))
        
        do {
            let todos = try context.fetch(request)
            todos.forEach { todo in
                todo.isArchived = false
            }
            saveContext()
        } catch {
            print("Error Unarchiving All: \(error.localizedDescription)")
        }
    }
    
    func removeTodo(_ todo: Todo){
        todo.isRemoved = true
        saveContext()
    }
    
    func unRemoveTodo(_ todo: Todo) {
        todo.isRemoved = false
        saveContext()
    }
    
    func unRemoveAll() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: true))
        
        do {
            let todos = try context.fetch(request)
            todos.forEach { todo in
                todo.isRemoved = false
            }
            saveContext()
        } catch {
            print("Error Unremoving All: \(error.localizedDescription)")
        }
    }
    
    func editTodos(_ todo: Todo, newTitle: String? = nil, newDesc: String? = nil, newIsDone: Bool? = nil, newPriority: Int16? = nil, newDueDate: Date? = nil, newTags: [Tag]? = nil){
        if let newTitle, !newTitle.isEmpty {
            todo.title = newTitle
        }
        if let newDesc{
            if newDesc.trimmingCharacters(in: .newlines).isEmpty{
                todo.desc = nil
            } else {
                todo.desc = newDesc.trimmingCharacters(in: .newlines).capitalized
            }
        }
        if let newIsDone{
            todo.isDone = newIsDone
        }
        if let newPriority{
            todo.priority = newPriority
        }
        if let newDueDate{
            todo.dueDate = newDueDate
        }
        if let newTags{
            todo.tags = NSSet(array: newTags)
        }
        saveContext()
    }
    
    func completeTodo(_ todo: Todo){
        todo.isDone = true
        todo.completionDate = Date()
        saveContext()
        print("Complete todo: \(todo.title ?? "")")
    }
    
    func uncompleteTodo(_ todo: Todo) {
        todo.isDone = false
        todo.completionDate = nil
        saveContext()
        print("Uncomplete todo: \(todo.title ?? "")")
    }
    
    func deleteTodo(_ todo: Todo) {
        context.delete(todo)
        saveContext()
    }
    
    func deleteAllRemovedTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: true))
        
        do {
            let todos = try context.fetch(request)
            todos.forEach { todo in
                context.delete(todo)
            }
            saveContext()
        } catch {
            print("Error Deleting All Removed Todos: \(error.localizedDescription)")
        }
    }
    
    func deleteTodoByIndex(at offsets: IndexSet){
        offsets.forEach { index in
            let todo = todos[index]
            context.delete(todo)
        }
        saveContext()
    }
    
    func removeTodoByIndex(at offsets: IndexSet) {
        offsets.forEach { index in
            let todo = todos[index]
            removeTodo(todo)
        }
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
    
    func addADayTodo(_ todo: Todo) {
        if let dueDate = todo.dueDate {
            if let newDueDate = Calendar.current.date(byAdding: .day, value: 1, to: dueDate) {
                todo.dueDate = newDueDate
            }
        } else {
            if let newDueDate = Calendar.current.date(byAdding: .day, value: 1, to: .now){
                todo.dueDate = newDueDate
            }
        }
        saveContext()
    }
    
    func makeTodoToday(_ todo: Todo){
        todo.dueDate = .now
        saveContext()
    }
    
    func removeADayTodo(_ todo: Todo) {
        if let dueDate = todo.dueDate{
            if let newDueDate = Calendar.current.date(byAdding: .day, value: -1, to: dueDate){
                todo.dueDate = newDueDate
            }
        } else {
            if let newDueDate = Calendar.current.date(byAdding: .day, value: -1, to: .now){
                todo.dueDate = newDueDate
            }
        }
        saveContext()
    }
    
    private func saveContext(){
        PersistentController.shared.saveContext()
        fetchAllTodos()
    }
    
}

extension TodoViewModel{
    static func mockToDo() -> Todo{
        let mocktodo = Todo(context: PersistentController.shared.context)
        mocktodo.id = UUID()
        mocktodo.title = "Make a coffee"
        mocktodo.desc = "Make a cofee for my friend which comes tomorrow"
        mocktodo.priority = 2
        mocktodo.dueDate = Date.now
        mocktodo.tags = NSSet(array: TagViewModel.mockTags())
        
        return mocktodo
    }
}
