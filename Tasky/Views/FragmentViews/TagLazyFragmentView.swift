//
//  TagLazyFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct TagLazyFragmentView: View {
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var selectedTags: [Tag]
    
    @State private var isAddingTag: Bool = false
    
    var colorTheme: Color {
        return settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
        
    var body: some View {
        VStack(alignment:.leading, spacing: 10){
            HStack(spacing: 0){
                Text("Tags: \(selectedTags.count)")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal,22)
                
                if selectedTags.count == 5{
                    Text("Max 5")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.red.opacity(0.8))
                }
            }
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(tagVM.tags, id: \.self) { tag in
                        Button(action: {addToSelection(tag: tag)}){
                            TagCapsuleView(tag: tag, showsSelection: true, selectedTags: $selectedTags)
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
                            .background(colorTheme, in:.circle)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(maxHeight: 40)
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $isAddingTag) {
            AddingTagView(tagVM: tagVM, settingsMgrVm: settingsMgrVM)
                .presentationDetents([.large])
                .interactiveDismissDisabled()
        }
    }
    
    func addToSelection(tag: Tag) {
        !selectedTags.contains(tag) && selectedTags.count <= 4 ? selectedTags.append(tag) : selectedTags.removeAll(where: {$0 == tag})
    }
    
    func foregroundForTagColor(tag: Tag) -> Color {
        return areColorsEqual(color1: Tag.getColor(from: tag), color2: .gray.opacity(0.3)) ? .black : .white
    }
    
    func isSelected(tag: Tag) -> Bool{
        selectedTags.contains(where: { $0 == tag })
    }
}

#Preview {
    TagLazyFragmentView(tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, selectedTags: .constant(TagViewModel.mockTags()))
}
