//
//  AddingTagView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct AddingTagView: View {
    @ObservedObject var tagVM: TagViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var selectedColor: Color = .gray.opacity(0.3)
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HStack{
                    Text("Add Tag")
                        .font(.system(.title, design: .rounded, weight: .semibold))
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Constants.secondaryColor)
                }
                .padding(.horizontal, 10)
                VStack(alignment: .leading){
                    Text("Name")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                    TextFieldComponent(text: $name, placeholder: "Name", maxChars: 30)
                        .focused($isFocused)
                        .padding(.vertical, 10)
                        .frame(maxWidth: Constants.screenWidth - 20)
                        .frame(maxHeight: 40)
                        .background(Constants.textFieldColor, in:.capsule)
                        .submitLabel(.done)
                        .onSubmit({isFocused = false})
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                }
                .padding(.vertical, 10)
                VStack(alignment: .leading){
                    Text("Color of tag")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,15)
                    showAllColors()
                        .padding(.horizontal,10)
                    
                }
                .padding(.vertical, 10)
            }
            .onAppear(perform: {isFocused = true})
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    Button(action: checkName){
                        Text("+ Tag")
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: Constants.screenWidth - 20)
                            .frame(height: 50)
                            .background(Color.accentColor, in:.capsule)
                            .padding(.bottom, 15)
                    }
                }
            }
            .alert("Invalid name", isPresented: $showAlert) {
                Button(action: {alertMessage = ""}){
                    Text("OK")
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    @ViewBuilder
    func showAllColors() -> some View{
        let colors: [Color] = [.blue, .yellow, .brown, .green, .red, .cyan, .purple, .pink, .orange]
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(colors, id: \.hashValue) { color in
                    ZStack{
                        Button{
                            withAnimation {
                                selectedColor = color
                            }
                        } label: {
                            Rectangle().fill(color)
                                .frame(width: 60)
                                .frame(height: 50)
                                .border(Color.black.opacity(0.2))
                                .padding(.horizontal,5)
                        }
                        
                        if areColorsEqual(color1: selectedColor, color2: color){
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 30)
                                .frame(height: 30)
                                .foregroundStyle(areColorsEqual(color1: selectedColor, color2: .gray.opacity(0.3)) ? .blue : .white)
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    func checkName() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        if trimmedName.isEmpty || trimmedName.count < 2 {
            alertMessage = "Oops.. Tag should be more than 3 characters!"
            showAlert.toggle()
        } else if tagVM.isTagByNameReserved(name){
            alertMessage = "Tag with this name already exists"
            showAlert.toggle()
        } else{
            tagVM.createTag(name, color: selectedColor)
            dismiss()
        }
    }
    
}

#Preview {
    AddingTagView(tagVM: TagViewModel())
}
