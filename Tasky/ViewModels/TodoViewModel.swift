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

@MainActor
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
                Task{
                    await self?.fetchTodayTodos(for: newDay)
                }
            }
            .store(in: &cancellables)
    }
    // MARK: - CREATING
    func createTodo(title: String, description: String?, priority: Int16, dueDate: Date?, tags: [Tag], isSaved: Bool = false) async throws -> Todo {
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
    
        try saveContext()
        
        return newTodo
    }
    
    // MARK: - EDITING
    func editTodos(_ todo: Todo, newTitle: String? = nil, newDesc: String? = nil, newIsDone: Bool? = nil, newPriority: Int16? = nil, newDueDate: Date? = nil, newTags: [Tag]? = nil) throws {
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
        try saveContext()
    }
    
    // MARK: - FETCHING
    func fetchAllTodos() {
        Task{
            await fetchArchivedTodos()
            await fetchRemovedTodos()
            await fetchSavedTodos()
            await fetchTodayTodos(for: calendarSet.currentDay)
        }
    }
    
    func fetchTodayTodos(for day: Date) async {
        let request: NSFetchRequest = Todo.fetchRequest()
        let archivePredicate = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let removedPredicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        
        let startOfDay = Calendar.current.startOfDay(for: day)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let datePredicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [archivePredicate, removedPredicate, datePredicate])
        
        do {
            todayTodos = try context.fetch(request)
        } catch {
            logger.log("Couldn't fetch todos for the day: \(day). Error: \(error.localizedDescription)")
        }
        
    }
    
    func fetchSavedTodos() async {
        let request: NSFetchRequest = Todo.fetchRequest()
        
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        request.predicate = NSPredicate(format: "isSaved == %@", NSNumber(value: true))
        
        do {
            savedTodos = try context.fetch(request)
        } catch {
            logger.log("Couldn't fetch saved todos: \(error.localizedDescription)")
        }
        
    }
    
    func fetchRemovedTodos() async {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isRemoved == %@", NSNumber(value: true))
    
        do {
            removedTodos = try context.fetch(request)
        } catch {
            logger.log("Couldn't fetch removed todos: \(error.localizedDescription)")
        }
    }
    
    func fetchArchivedTodos() async {
        let request: NSFetchRequest = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "isArchived == %@", NSNumber(value: true))
        do {
            archivedTodos = try context.fetch(request)
        } catch {
            logger.log("Couldn't fetch archived todos: \(error.localizedDescription)")
        }
    }
    
    func fetchCompletedTodos() async {
        let request: NSFetchRequest = Todo.fetchRequest()
        let isDonePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        request.predicate = isDonePredicate
     
        do {
            let todos = try context.fetch(request)
            todos.forEach { todo in
                archive(todo)
            }
        } catch {
            logger.log("Couldn't fetch completed todos: \(error.localizedDescription)")
        }
    }
    
    // MARK: - DELETING
    func deleteTodo(_ todo: Todo) {
        context.delete(todo)
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't delete todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func deleteAllRemovedTodos() {
        removedTodos.forEach { context.delete($0) }
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't delete all removed todos: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func deleteAllTodos() {
        let request: NSFetchRequest<NSFetchRequestResult> = Todo.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try saveContext()
        } catch {
            logger.log("Couldn't delete all todos: Eror while saving the context or executing delete request: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - ARCHIVE ACTIONS
    func archive(_ todo: Todo) {
        todo.isArchived = true
        
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't archive todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func unArchive(_ todo: Todo) {
        todo.isArchived = false
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't unarchive todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func archiveOldCompletedTodos() async {
        let isArchiveAfterCompletionEnabled = UserDefaults.standard.bool(forKey: "isArchiveAfterCompletionEnabled")
        guard isArchiveAfterCompletionEnabled else { logger.log("Archiving after completion is not enabled."); return }
        logger.log("Archive old completed Todos: \(isArchiveAfterCompletionEnabled ? "Yes" : "No")")
        
        let archiveAfterDays = UserDefaults.standard.integer(forKey: "archiveAfterDays")
        logger.log("Archive completed todos after: \(archiveAfterDays)")
        
        let xDaysAgo = Calendar.current.date(byAdding: .day, value: -archiveAfterDays, to: Date())!
        logger.log("Xdays Ago: \(xDaysAgo)")
        
        let request: NSFetchRequest = Todo.fetchRequest()
        let predicate1 = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        let predicate2 = NSPredicate(format: "isArchived == %@", NSNumber(value: false))
        let predicate3 = NSPredicate(format: "isRemoved == %@", NSNumber(value: false))
        let predicate4 = NSPredicate(format: "completionDate <= %@", xDaysAgo as NSDate)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2, predicate3, predicate4])
        
        do {
            let todosToArchive = try context.fetch(request)
            guard !todosToArchive.isEmpty else { logger.log("Didn't find old completed todos."); return }
            todosToArchive.forEach { todo in
                logger.log("Found old completed todo: \(todo.title ?? "Test Title")")
                todo.isArchived = true
            }
            try saveContext()
        } catch {
            print("Failed to archive old completed Todo:\(error.localizedDescription)")
        }
    }
    
    func unArchiveAll() {
        archivedTodos.forEach { $0.isArchived = false}
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't unarchive all archived todos: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - REMOVING
    func removeTodo(_ todo: Todo) {
        todo.isRemoved = true
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't remove todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func unRemoveTodo(_ todo: Todo) {
        todo.isRemoved = false
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't unarchive todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func unRemoveAll() {
        removedTodos.forEach { $0.isRemoved = false }
        
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't unremove all todos: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - COMPLETING
    func completeTodo(_ todo: Todo) {
        todo.isDone = true
        todo.completionDate = Date()
        
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't complete todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func uncompleteTodo(_ todo: Todo) {
        todo.isDone = false
        todo.completionDate = nil
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't uncomplete todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - SAVING
    func saveTodo(_ todo: Todo){
        todo.isSaved = true
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't save todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    func unsaveTodo(_ todo: Todo){
        todo.isSaved = false
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't unsave todo: Eror while saving the context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - SAVING
    private func saveContext() throws {
        try PersistentController.shared.saveContext()
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
