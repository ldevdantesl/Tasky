//
//  TagLazyFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct TagLazyFragmentView: View {
    @ObservedObject var tagVM: TagViewModel
    
    @Binding var selectedTags: [Tag]
    
    @State private var isAddingTag: Bool = false
        
    var body: some View {
        VStack(alignment:.leading, spacing: 10){
            Text("Tags")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal,22)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(tagVM.tags, id: \.self) { tag in
                        Button(action: {addToSelection(tag: tag)}){
                            HStack{
                                Text("#\(tag.name ?? "")")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                    .foregroundStyle(foregroundForTagColor(tag: tag))
                                if isSelected(tag: tag){
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(foregroundForTagColor(tag: tag))
                                }
                            }
                            .padding(10)
                            .background(Tag.getColor(from: tag) ?? .gray.opacity(0.3), in:.capsule)
                        }
                        .contextMenu {
                            if selectedTags.contains(where: { $0 == tag }) {
                                Text("Can't remove it is used")
                                    .font(.system(.caption, design: .rounded, weight: .semibold))
                            }
                            
                            Button(role:.destructive, action: {tagVM.deleteTag(tag: tag)}){
                                    Text("Remove tag")
                            }
                            .disabled(selectedTags.contains(where: { $0 == tag }))
                            
                        }
                    }
                    Button(action: {isAddingTag.toggle()}){
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 25)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Color.blue, in:.circle)
                    }
                }
                .padding(.horizontal, 15)
            }
            .frame(maxHeight: 40)
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $isAddingTag, onDismiss: tagVM.fetchTags) {
            AddingTagView(tagVM: tagVM)
                .presentationDetents([.medium, .large])
        }
    }
    
    func addToSelection(tag: Tag) {
        if selectedTags.contains(tag){
            selectedTags.removeAll(where: {$0 == tag})
        } else {
            selectedTags.append(tag)
        }
    }
    
    func foregroundForTagColor(tag: Tag) -> Color {
        if areColorsEqual(color1: Tag.getColor(from: tag), color2: .gray.opacity(0.3)){
            return .black
        } else {
            return .white
        }
    }
    
    func isSelected(tag: Tag) -> Bool{
        if selectedTags.contains(where: { $0 == tag }){
            return true
        } else {
            return false
        }
    }
}

#Preview {
    TagLazyFragmentView(tagVM: TagViewModel(), selectedTags: .constant([]))
}
