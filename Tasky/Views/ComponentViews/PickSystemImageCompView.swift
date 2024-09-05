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
    
    @State private var selectedCategory: String = "Popular"
    
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
            
            VStack(alignment: .leading){
                Menu {
                    ForEach(TagImagesCategory.allCategories, id:\.self){ cat in
                        Button("\(cat.name)", systemImage: cat.titleImage, action: {self.selectedCategory = cat.name})
                    }
                } label: {
                    Text(selectedCategory)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    Image(systemName: "chevron.up.chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 25)
                    .fill(Constants.textFieldColor)
                    .frame(maxWidth: Constants.screenWidth - 20, maxHeight: Constants.screenHeight / 3)
                    .overlay {
                        LazyVGrid(columns: columns, spacing: 20){
                            ForEach(TagImagesCategory.allCategories, id: \.self) { cat in
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 45, height: 45)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 30)
                    }
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    PickSystemImageCompView(selectedImage: .constant("bookmark.fill"), selectedColor: .constant(.blue))
}
