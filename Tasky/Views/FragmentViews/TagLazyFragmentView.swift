//
//  TagLazyFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct TagLazyFragmentView: View {
    @ObservedObject var tagVM = TagViewModel()
    
    @Binding var selectedTags: [Tag]
    
    @State private var isAddingTag: Bool = false
        
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Text("Tags")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal,5)
            }
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
                            .background(getColor(from: tag) ?? .gray.opacity(0.3), in:.capsule)
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
                            .shadow(radius: 5)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 70)
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $isAddingTag, onDismiss: tagVM.fetchTags) {
            NavigationStack{
                AddingTagView()
            }
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
        if areColorsEqual(color1: getColor(from: tag), color2: .gray.opacity(0.3)){
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
    TagLazyFragmentView(selectedTags: .constant([]))
}
