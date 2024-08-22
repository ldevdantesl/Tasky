//
//  DataManger.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import Foundation
import CoreData
import SwiftUI

class PersistentController: ObservableObject {
    static let shared: PersistentController = PersistentController()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init(){
        self.container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext(){
        if context.hasChanges{
            do { try context.save() } catch {
                print("Cant save context: \(error.localizedDescription)")
            }
        }
    }
}


