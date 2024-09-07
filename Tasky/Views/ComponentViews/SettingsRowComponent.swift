//
//  SettingsRowComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 6.09.2024.
//

import SwiftUI

struct SettingsRowComponent: View {
    let title: String
    let subtitle: String?
    let image: String
    let color: Color
    let link: String?
    let action: (() -> ())?
    @State private var showingDropDown: Bool = false
    
    @Binding var isDropDown: Int
    @Binding var toggler: Bool
    @Binding var path: NavigationPath
    
    let dropDownVariations: [Int] = [5, 10, 15, 20]
    
    init(title: String, subtitle: String? = nil, image: String, color: Color, toggler: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self.action = nil
        self.link = nil
        self._toggler = toggler
        self._path = .constant(NavigationPath())
        self._isDropDown = .constant(0)
    }
    
    init(title: String, subtitle: String? = nil, image: String, color: Color, link: String, path: Binding<NavigationPath>) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self.link = link
        self._path = path
        self.action = nil
        self._toggler = .constant(false)
        self._isDropDown = .constant(0)
    }
    
    init(title: String, subtitle: String? = nil, image: String, color: Color, action: (() -> ())?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self.link = nil
        self.action = action
        self._toggler = .constant(false)
        self._path = .constant(NavigationPath())
        self._isDropDown = .constant(0)
    }
    
    init(title: String, subtitle: String? = nil, image: String, color: Color, isDropDown: Binding<Int>) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self._isDropDown = isDropDown
        self._toggler = .constant(false)
        self._path = .constant(NavigationPath())
        self.link = nil
        self.action = nil
    }
    
    var body: some View {
        VStack{
            Button{
                withAnimation(.bouncy){
                    if let link{
                        path.append(link)
                    } else if let action {
                        action()
                    } else if isDropDown != 0 {
                        showingDropDown.toggle()
                    } else {
                        toggler.toggle()
                    }
                }
            } label: {
                Capsule()
                    .fill(Constants.textFieldColor)
                    .frame(width: Constants.screenWidth - 20, height: 55)
                    .overlay{
                        HStack(spacing: 10){
                            Circle()
                                .fill(color.gradient)
                                .frame(height: 45)
                                .overlay {
                                    Image(systemName: image)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 25, height: 25)
                                }
                            VStack(alignment:.leading){
                                Text(title)
                                    .font(.system(.headline, design: .rounded, weight: .medium))
                                if let subtitle {
                                    Text(subtitle)
                                        .font(.system(.caption, design: .rounded, weight: .light))
                                        .foregroundStyle(Constants.secondaryColor)
                                }
                            }
                            Spacer()
                            if link != nil {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 20)
                            } else if isDropDown != 0 {
                                Image(systemName: showingDropDown ? "chevron.up" : "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 20)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(.plain)
            
            if showingDropDown {
                HStack{
                    ForEach(dropDownVariations, id: \.self){ variation in
                        Capsule()
                            .fill(isDropDown == variation ? color : Constants.textFieldColor)
                            .frame(width: 80, height: 55)
                            .overlay{
                                Text("\(variation)")
                                    .font(.system(.subheadline, design: .rounded, weight: .light))
                                    .foregroundStyle(isDropDown == variation ? .white : .black)
                            }
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    isDropDown = variation
                                    showingDropDown.toggle()
                                }
                            }
                    }
                }
                .padding(.top, 15)
            }
        }
    }
}

#Preview {
    SettingsRowComponent(title: "Tags",subtitle: "Lets just see",image: "number", color: .blue, isDropDown: .constant(20))
}
