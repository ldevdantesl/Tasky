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
    
    func createTag(_ name: String, color: Color = .gray.opacity(0.3)) {
        let newTag = Tag(context: context)
        newTag.id = UUID()
        newTag.name = name
        newTag.color = color.toData()
        
        saveContext()
    }
    
    func editTag(tag: Tag, newName: String, newColor: Color){
        tag.name = newName
        tag.color = newColor.toData()
        saveContext()
    }
    
    func deleteTag(tag: Tag){
        context.delete(tag)
        saveContext()
    }
    
    private func saveContext(){
        PersistentController.shared.saveContext()
        fetchTags()
    }
}

extension Tag{
    static func areTagsEqual(nsset: NSSet, array: [Tag]) -> Bool {
        let nssetSet = Set(nsset as! Set<Tag>)
        let arraySet = Set(array)
        return nssetSet == arraySet
    }
}

extension Tag{
    static func getColor(from tag: Tag) -> Color? {
        guard let colorData = tag.color else { return nil }
        return Color.fromData(colorData)
    }
}

#if DEBUG
extension TagViewModel{
    static func mockTags() -> [Tag]{
        let newTag = Tag(context: PersistentController.shared.context)
        newTag.id = UUID()
        newTag.name = "Kitchen Work and bla bla bla bla bla bla"
        newTag.color = Color.gray.opacity(0.3).toData()
        
        let newTag2 = Tag(context: PersistentController.shared.context)
        newTag2.id = UUID()
        newTag2.name = "Home Work"
        newTag2.color = Color.blue.toData()
        
        return [newTag, newTag2]
    }
}
#endif

