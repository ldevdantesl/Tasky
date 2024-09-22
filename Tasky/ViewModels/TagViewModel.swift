//
//  TagViewModel.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import Foundation
import SwiftUI
import CoreData

class TagViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    
    let context = PersistentController.shared.context
    
    init() {
        fetchTags()
    }
    
    func fetchTags(){
        let request: NSFetchRequest<Tag> = Tag.fetchRequest()
        request.sortDescriptors = []
        
        do {
            tags = try context.fetch(request)
        } catch {
            print("Error fetching Tags: \(error.localizedDescription)")
        }
    }
    
    func isTagByNameReserved(_ name: String) -> Bool {
        if tags.contains(where: {$0.name == name}){
            return true
        } else {
            return false
        }
    }
    
    func isTagByImageReserved(_ systemImage: String) -> Bool {
        if tags.contains(where: { $0.systemImage == systemImage }){
            return true
        } else {
            return false
        }
    }
    
    func createTag(_ name: String, color: Color, systemImage: String) throws {
        let newTag = Tag(context: context)
        newTag.id = UUID()
        newTag.name = name
        newTag.color = color.toData()
        newTag.systemImage = systemImage
        
        try saveContext()
    }
    
    func editTag(tag: Tag, newName: String, newColor: Color){
        tag.name = newName
        tag.color = newColor.toData()

        do {
            try saveContext()
        } catch {
            logger.log("Couldn't edit tag. Error while saving the context: \(error.localizedDescription)")
        }
    }
    
    func deleteTag(tag: Tag){
        context.delete(tag)
        do {
            try saveContext()
        } catch {
            logger.log("Couldn't delete tag. Error while saving the context: \(error.localizedDescription)")
        }
    }
    
    func deleteAllTags() {
        let request: NSFetchRequest = Tag.fetchRequest()
        
        do {
            let tags = try context.fetch(request)
            tags.forEach { tag in
                deleteTag(tag: tag)
            }
        } catch {
            print("Error deleting all tags: \(error.localizedDescription)")
        }
    }
    
    private func saveContext() throws {
        try PersistentController.shared.saveContext()
        fetchTags()
    }
}

extension Tag{
    static func areTagsEqual(nsset: NSSet, array: [Tag]) -> Bool {
        let nssetSet = Set(nsset as! Set<Tag>)
        let arraySet = Set(array)
        return nssetSet == arraySet
    }
    
    static func getColor(from tag: Tag) -> Color? {
        guard let colorData = tag.color else { return nil }
        return Color.fromData(colorData)
    }
    
    static func foregroundForTagColor(tag: Tag) -> Color {
        return areColorsEqual(color1: Tag.getColor(from: tag), color2: .gray.opacity(0.3)) ? .black : .white
    }
}

extension TagViewModel{
    static func mockTags() -> [Tag]{
        let newTag = Tag(context: PersistentController.shared.context)
        newTag.id = UUID()
        newTag.name = "Work"
        newTag.systemImage = "bag.fill"
        newTag.color = Color.blue.toData()
        
        let newTag2 = Tag(context: PersistentController.shared.context)
        newTag2.id = UUID()
        newTag2.name = "Personal"
        newTag2.systemImage = "person"
        newTag2.color = Color.purple.toData()
        
        return [newTag, newTag2]
    }
}
