//
//  TagCapsuleView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 6.09.2024.
//

import SwiftUI

struct TagCapsuleView: View {
    @ObservedObject var tagVM: TagViewModel
    
    @Binding var selectedTags: [Tag]
    
    @State private var showTodoForTag: Bool = false
    
    let tag: Tag
    let showsSelection: Bool
    
    init(tag: Tag, showsSelection: Bool = true, selectedTags: Binding<[Tag]>, tagVM: TagViewModel) {
        self.tag = tag
        self.showsSelection = showsSelection
        self._selectedTags = selectedTags
        self.tagVM = tagVM
    }
    
    init(tag: Tag, tagVM: TagViewModel) {
        self.tag = tag
        self.showsSelection = false
        self._selectedTags = .constant([])
        self.tagVM = tagVM
    }
    
    var body: some View {
        HStack{
            Text("#\(tag.name ?? "")")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(Tag.foregroundForTagColor(tag: tag))
            
            Image(systemName: tag.systemImage ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(.white)
            
            if showsSelection{
                if isSelected(tag: tag){
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Tag.foregroundForTagColor(tag: tag))
                }
            }
        }
        .padding(10)
        .background(Tag.getColor(from: tag) ?? .gray.opacity(0.3), in:.capsule)
        .contextMenu{
            if !showsSelection{
                Button("See All todos", systemImage: "checklist", action: {showTodoForTag.toggle()})
            }
            Button("Delete tag", systemImage: "trash.fill"){
                withAnimation {
                    tagVM.deleteTag(tag: tag)
                }
            }
        }
        .sheet(isPresented: $showTodoForTag){
            TodosForTagFragmentView(tag: tag)
        }
    }
    
    func isSelected(tag: Tag) -> Bool{
        selectedTags.contains(where: { $0 == tag })
    }
}

#Preview {
    TagCapsuleView(tag: TagViewModel.mockTags()[0], showsSelection: true, selectedTags: .constant([]),tagVM: TagViewModel())
}
