//
//  TodoViewModel.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class TodoViewModel: ObservableObject {
    @AppStorage("isFirstEntry") var isFirstEntry = false
    
    @Published var standardTodos: [Todo] = []
    @Published var todayTodos: [Todo] = []
    @Published var savedTodos: [Todo] = []
    @Published var removedTodos: [Todo] = []
    @Published var archivedTodos: [Todo] = []
    
    @Published var sortDescriptor: NSSortDescriptor? {
        didSet {
            fetchAllTodos()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let calendarSet = CalendarSet.instance
    
    let context = PersistentController.shared.context
    
    init() {
        fetchAllTodos()
        observeCurrentDay()
    }
    
    private func observeCurrentDay() {
        calendarSet.$currentDay
            .sink { [weak self] newDay in
                self?.fetchTodayTodos(for: newDay)
            }
            .store(in: &cancellables)
    }
    // MARK: - CREATING
    func createTodo(title: String, description: String?, priority: Int16, dueDate: Date?, tags: [Tag], isSaved: Bool = false) -> Todo {
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
        newTodo.isSaved = isSaved
        
        if !tags.isEmpty{
            newTodo.tags = NSSet(array: tags)
        }
    
        saveContext()
        
        return newTodo
    }
    
    // MARK: - EDITING
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
    
    // MARK: - FETCHING
    func fetchAllTodos(){
        fetchArchivedTodos()
        fetchRemovedTodos()
        fetchSavedTodos()
        fetchTodayTodos(for: calendarSet.currentDay)
    }
    
    func fetchTodayTodos(for day: Date) {
        let request: NSFetchRequest = Todo.fetchRequest()
        let archivePredicate = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let removedPredicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        
        let startOfDay = Calendar.current.startOfDay(for: day)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let datePredicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [archivePredicate, removedPredicate, datePredicate])
        
        if let sortDescriptor {
            request.sortDescriptors = [sortDescriptor]
        }
        
        do {
            todayTodos = try context.fetch(request)
        } catch {
            print("Error fetching removed Todos: \(error.localizedDescription)")
        }
    }
    
    func fetchSavedTodos() {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        request.predicate = NSPredicate(format: "isSaved == %@", NSNumber(value: true))
        
        do {
            savedTodos = try context.fetch(request)
        } catch {
            print("Error fetching saved Todos: \(error.localizedDescription)")
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
    
    func fetchCompletedTodos() {
        
        let request: NSFetchRequest = Todo.fetchRequest()
        let isDonePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        request.predicate = isDonePredicate
        do {
            let todos = try context.fetch(request)
            todos.forEach { todo in
                archive(todo)
            }
        } catch {
            print("Error fetching completed todos: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - DELETING
    func deleteTodo(_ todo: Todo) {
        context.delete(todo)
        saveContext()
    }
    
    func deleteAllRemovedTodos() {
        removedTodos.forEach { context.delete($0) }
        saveContext()
    }
    
    func deleteAllTodos(){
        let request: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting all todos: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - ARCHIVE ACTIONS
    func archive(_ todo: Todo) {
        todo.isArchived = true
        saveContext()
    }
    
    func unArchive(_ todo: Todo){
        todo.isArchived = false
        saveContext()
    }
    
    func unArchiveAll() {
        archivedTodos.forEach { $0.isArchived = false}
        saveContext()
    }
    
    // MARK: - REMOVING
    func removeTodo(_ todo: Todo){
        todo.isRemoved = true
        saveContext()
    }
    
    func unRemoveTodo(_ todo: Todo) {
        todo.isRemoved = false
        saveContext()
    }
    
    func unRemoveAll() {
        removedTodos.forEach { $0.isRemoved = false }
        saveContext()
    }
    
    // MARK: - COMPLETING
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
    
    // MARK: - SAVING
    func saveTodo(_ todo: Todo){
        todo.isSaved = true
        saveContext()
    }
    
    func unsaveTodo(_ todo: Todo){
        todo.isSaved = false
        saveContext()
    }
    
    // MARK: - SAVING
    private func saveContext(){
        PersistentController.shared.saveContext()
        fetchAllTodos()
    }
    
}

extension TodoViewModel{
    static func mockToDo() -> Todo{
        let mocktodo = Todo(context: PersistentController.shared.context)
        mocktodo.id = UUID()
        mocktodo.title = "Manage the schedule"
        mocktodo.desc = "Schedule the time for my co-worker"
        mocktodo.priority = 1
        mocktodo.dueDate = Date.now
        mocktodo.isSaved = true
        mocktodo.tags = NSSet(array: TagViewModel.mockTags())
        
        return mocktodo
    }
}
