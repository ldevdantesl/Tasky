//
//  AddingTagView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct AddingTagView: View {
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVm: SettingsManagerViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var selectedColor: Color = .blue
    @State var selectedImage: String = "bookmark.fill"
    @State private var nameError: String?
    @State private var tagError: String?
    @State private var isLoading: Bool = false
    @FocusState var isFocused: Bool
    
    var colorTheme: Color {
        settingsMgrVm.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        ScrollView{
            HStack{
                Text("Add Tag")
                    .font(.system(.title, design: .rounded, weight: .semibold))
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Constants.secondaryColor)
                    .onTapGesture {
                        dismiss()
                    }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            VStack(alignment: .leading){
                Text("Name")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal,5)
                TextFieldComponent(text: $name, placeholder: "Name", maxChars: 20)
                    .focused($isFocused)
                    .padding(.vertical, 10)
                    .frame(maxWidth: Constants.screenWidth - 20)
                    .frame(maxHeight: 40)
                    .background(Constants.textFieldColor, in:.capsule)
                    .submitLabel(.done)
                    .onSubmit({isFocused = false})
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .onChange(of: name) { _ in
                        nameError = nil
                    }
                
                if let nameError{
                    Text(nameError)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.red.opacity(0.8))
                        .padding(.horizontal, 15)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 0){
                PickSystemImageCompView(selectedImage: $selectedImage, selectedColor: $selectedColor)
                    .padding(.bottom, 15)
                
                if let tagError {
                    Text(tagError)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.red.opacity(0.8))
                        .padding(.horizontal, 15)
                }
            }
            
            VStack(alignment: .leading){
                Text("Color of tag")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal,20)
                showAllColors()
            }
            .padding(.vertical, 10)
            
            Button(action: addTag){
                Text("+ Tag")
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .frame(maxWidth: Constants.screenWidth - 40)
                    .frame(height: 40)
                    .background(colorTheme, in: .capsule)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 10)
        }
        .onAppear(perform: {isFocused = true})
        .background(Constants.backgroundColor)
        .disabled(isLoading)
        .overlay{
            if isLoading {
                ProgressView()
                    .frame(width: 100, height: 100)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 25))
            }
        }
    }
    
    @ViewBuilder
    func showAllColors() -> some View{
        let colors: [Color] = [.blue, .yellow, .brown, .green, .red, .cyan, .purple, .pink, .orange]
        ScrollView(.horizontal){
            LazyHStack(spacing: 10){
                ForEach(colors, id: \.hashValue) { color in
                    Button{
                        withAnimation {
                            selectedColor = color
                        }
                    } label: {
                        Circle().fill(color)
                            .frame(width: 50)
                            .frame(height: 50)
                            .padding(.horizontal,5)
                            .overlay{
                                if areColorsEqual(color1: selectedColor, color2: color){
                                    Circle()
                                        .fill(areColorsEqual(color1: selectedColor, color2: .gray.opacity(0.3)) ? .blue : .white)
                                        .frame(maxWidth: 25)
                                        .frame(height: 25)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 15)
        }
        .scrollIndicators(.hidden)
    }
    
    func addTag() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            if name.count > 2 && !name.trimmingCharacters(in: .whitespaces).isEmpty && !tagVM.isTagByImageReserved(selectedImage) && !tagVM.isTagByNameReserved(name) {
                print("Creating the tag...")
                tagVM.createTag(name, color: selectedColor, systemImage: selectedImage)
                dismiss()
            } else {
                print("Something went wrong while creating tags")
                withAnimation {
                    if name.count < 3 {
                        nameError = "Tag should be more than 3 characters"
                    } else if name.trimmingCharacters(in: .whitespaces).isEmpty {
                        nameError = "Tag can't be only the spaces"
                    } else if tagVM.isTagByNameReserved(name) {
                        nameError = "Tag with this name is already exists."
                    }
                    if tagVM.isTagByImageReserved(selectedImage) {
                        tagError = "Tag with this icon is already exists"
                    }
                }
            }
        }
    }
}

#Preview {
    AddingTagView(tagVM: TagViewModel(), settingsMgrVm: MockPreviews.viewModel)
}
