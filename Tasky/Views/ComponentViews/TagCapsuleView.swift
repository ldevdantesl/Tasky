//
//  TagCapsuleView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 6.09.2024.
//

import SwiftUI

struct TagCapsuleView: View {
    let tag: Tag
    let showsSelection: Bool
    
    @Binding var selectedTags: [Tag]
    
    init(tag: Tag, showsSelection: Bool = true, selectedTags: Binding<[Tag]>) {
        self.tag = tag
        self.showsSelection = showsSelection
        self._selectedTags = selectedTags
    }
    
    init(tag: Tag) {
        self.tag = tag
        self.showsSelection = false
        self._selectedTags = .constant([])
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
    }
    
    func isSelected(tag: Tag) -> Bool{
        selectedTags.contains(where: { $0 == tag })
    }
}

#Preview {
    TagCapsuleView(tag: TagViewModel.mockTags()[0], showsSelection: true, selectedTags: .constant([]))
}
