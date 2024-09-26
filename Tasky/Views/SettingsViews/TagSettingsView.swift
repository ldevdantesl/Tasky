//
//  TagSettingsView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 26.08.2024.
//

import SwiftUI

struct TagSettingsView: View {
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    
    @State private var deleteAllAlert: Bool = false
    @State private var isAddingTag: Bool = false
    
    var colorTheme: Color {
        settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            ScrollView(.horizontal){
                LazyHStack(spacing: 15){
                    ForEach(tagVM.tags, id: \.self) { tag in
                        TagCapsuleView(tag: tag, tagVM: tagVM)
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
                .padding(.horizontal, 25)
            }
            .scrollIndicators(.hidden)
            .frame(height: 50)
            .padding(.vertical, 10)
            
            SettingsRowComponent(title: "Add New Tag", subtitle: "Add new tag to the tag list.",image: "plus", color: .yellow, toggler: $isAddingTag)
                .padding(.horizontal, 10)
            
            SettingsRowComponent(title: "Remove All Tags", subtitle:"Remove all tags from the tag list.", image: "trash.fill", color: .red, toggler: $deleteAllAlert)
                .padding(.horizontal, 10)
            
            Spacer()
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Tags")
        .navigationBarTitleDisplayMode(.inline)
        .background(Constants.backgroundColor)
        .sheet(isPresented: $isAddingTag){
            AddingTagView(tagVM: tagVM, settingsMgrVm: settingsManagerVM)
                .presentationDetents([.large])
                .interactiveDismissDisabled()
        }
        .alert("Delete All", isPresented: $deleteAllAlert){
            Button("Delete", role:.destructive, action: tagVM.deleteAllTags)
        } message: {
            Text("Do you want to delete all the tags?")
        }
    }
}

#Preview {
    NavigationStack{
        TagSettingsView(tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
    }
}
