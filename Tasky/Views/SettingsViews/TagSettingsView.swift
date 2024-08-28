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
    
    @State private var deleteAllAlert: Bool = false
    
    let gridRows:[GridItem] = [
        GridItem(.flexible(minimum: (Constants.screenWidth / 4) - 20), spacing: 0),
        GridItem(.flexible(minimum: (Constants.screenWidth / 4) - 20), spacing: 0)
    ]
    
    var body: some View {
        NavigationStack{
            Form{
                Section("Tags"){
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: gridRows, spacing: 10){
                            ForEach(tagVM.tags) { tag in
                                Menu{
                                    Button("Remove", systemImage: "trash", role:.destructive) {
                                        tagVM.deleteTag(tag: tag)
                                    }
                                    
                                } label: {
                                    Text("#\(tag.name ?? "Uknown Tag")")
                                        .frame(maxWidth: (Constants.screenWidth / 2), maxHeight: 30, alignment: .leading)
                                        .foregroundStyle(.white)
                                        .padding(10)
                                        .background(Color.fromData(tag.color!) ?? .blue, in:.capsule)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .scrollIndicators(.hidden)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                if tagVM.tags.count > 0{
                    Section{
                        Button("Delete all",systemImage: "trash", role:.destructive) {
                            deleteAllAlert.toggle()
                        }
                        .alert("Delete all Tags", isPresented: $deleteAllAlert) {
                            Button("Delete", systemImage:"trash", role:.destructive){
                                tagVM.deleteAllTags()
                            }
                        } message: {
                            Text("Do you want to delete all the tags?")
                        }

                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TagSettingsView(tagVM: TagViewModel(), settingsManagerVM: MockPreviews.viewModel)
}
