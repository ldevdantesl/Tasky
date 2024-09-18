//
//  PickSystemImageCompView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 5.09.2024.
//

import SwiftUI

struct PickSystemImageCompView: View {
    @Binding var selectedImage: String
    @Binding var selectedColor: Color
    
    @State private var selectedCategory: TagImagesCategory = .allCategories[0]
    
    let columns: [GridItem] = Array(repeating: GridItem(.fixed(40), spacing: 15), count: 6)
    var body: some View {
        VStack{
            Circle()
                .fill(selectedColor)
                .frame(width: 65, height: 65)
                .overlay {
                    Image(systemName: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading){
                Picker("",selection: $selectedCategory) {
                    ForEach(TagImagesCategory.allCategories, id:\.self){ cat in
                        HStack{
                            Text(cat.name)
                            Image(systemName: cat.titleImage)
                        }
                        .tag(cat)
                    }
                }
                RoundedRectangle(cornerRadius: 25)
                    .fill(Constants.textFieldColor)
                    .frame(maxWidth: Constants.screenWidth - 20, maxHeight: Constants.screenHeight * 0.4)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .overlay {
                        LazyVGrid(columns: columns, spacing: 20){
                            ForEach(selectedCategory.symbols, id: \.self) { symbol in
                                Button{
                                    withAnimation {selectedImage = symbol}
                                } label: {
                                    Circle()
                                        .fill(selectedImage == symbol ? selectedColor : .customSecondary.opacity(0.3))
                                        .frame(width: Constants.screenWidth * 0.12, height: Constants.screenHeight * 0.07)
                                        .overlay{
                                            Image(systemName: symbol)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .foregroundStyle(selectedImage == symbol ? Color.white : Color.primary)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
            }
        }
        .padding(.horizontal, 10)
        .frame(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.56)
    }
}

#Preview {
    PickSystemImageCompView(selectedImage: .constant("folder"), selectedColor: .constant(.blue))
}
