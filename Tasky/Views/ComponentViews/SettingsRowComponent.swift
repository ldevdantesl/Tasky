//
//  SettingsRowComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 6.09.2024.
//

import SwiftUI

struct SettingsRowComponent: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey?
    let image: String
    let color: Color
    let link: String?
    let action: (() -> ())?
    let rightSideText: String?
    
    @State private var showingDropDown: Bool = false
    @State private var showingColorDropDown: Bool = false
    @State private var showingToggleState: Bool
    
    @Binding var isDropDown: Int
    @Binding var toggler: Bool
    @Binding var selectedColor: Color
    @Binding var path: NavigationPath
    
    let dropDownVariations: [Int]
    
    let dropDownColorVariations: [Color] = [.green, .blue, .red, .gray, .yellow, .teal, .mint, .brown, .orange, .cyan, .indigo]
    
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, image: String, color: Color, toggler: Binding<Bool>, showingToggleState: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self.dropDownVariations = []
        self.action = nil
        self.link = nil
        self._toggler = toggler
        self._path = .constant(NavigationPath())
        self._isDropDown = .constant(0)
        self._showingToggleState = State(wrappedValue: showingToggleState)
        self._selectedColor = .constant(.secondary)
        self.rightSideText = nil
    }
    
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, image: String, color: Color, link: String, path: Binding<NavigationPath>) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self.link = link
        self.dropDownVariations = []
        self._path = path
        self.action = nil
        self._toggler = .constant(false)
        self._isDropDown = .constant(0)
        self._showingToggleState = State(wrappedValue: false)
        self._selectedColor = .constant(.secondary)
        self.rightSideText = nil
    }
    
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, image: String, color: Color, rightSideText: String? = nil, action: (() -> ())?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self.action = action
        self.dropDownVariations = []
        self.link = nil
        self._toggler = .constant(false)
        self._path = .constant(NavigationPath())
        self._isDropDown = .constant(0)
        self._showingToggleState = State(wrappedValue: false)
        self._selectedColor = .constant(.secondary)
        self.rightSideText = rightSideText
    }
    
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, image: String, color: Color, isDropDown: Binding<Int>, dropDownVariations: [Int]) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self._isDropDown = isDropDown
        self.dropDownVariations = dropDownVariations
        self._toggler = .constant(false)
        self._path = .constant(NavigationPath())
        self.link = nil
        self.action = nil
        self._showingToggleState = State(wrappedValue: false)
        self._selectedColor = .constant(.secondary)
        self.rightSideText = nil
    }
    
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, image: String, color: Color, selectedColor: Binding<Color>) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.color = color
        self._isDropDown = .constant(0)
        self.dropDownVariations = []
        self._toggler = .constant(false)
        self._path = .constant(NavigationPath())
        self.link = nil
        self.action = nil
        self._showingToggleState = State(wrappedValue: false)
        self._selectedColor = selectedColor
        self.rightSideText = nil
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
                    } else if selectedColor != .secondary {
                        showingColorDropDown.toggle()
                    } else {
                        toggler.toggle()
                        print(toggler)
                    }
                }
            } label: {
                Capsule()
                    .fill(Constants.textFieldColor)
                    .frame(width: Constants.screenWidth - 20, height: 55)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .overlay{
                        HStack(spacing: 10){
                            Circle()
                                .fill(color.gradient)
                                .frame(height: 45)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 2)
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
                            } else if isDropDown != 0{
                                Image(systemName: showingDropDown ? "chevron.up" : "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            } else if selectedColor != .secondary{
                                Image(systemName: showingColorDropDown ? "chevron.up" : "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                            } else if showingToggleState, toggler{
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.green)
                            } else if let rightSideText{
                                Text(rightSideText)
                                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                            }
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 20)
                    }
                    
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
                                    .foregroundStyle(isDropDown == variation ? Color.white : Color.primary)
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
            } else if showingColorDropDown {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20){
                        ForEach(dropDownColorVariations, id:\.self){ color in
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 58)
                                .overlay {
                                    if selectedColor == color {
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectedColor = color
                                        showingColorDropDown.toggle()
                                    }
                                }
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 60)
                .scrollIndicators(.hidden)
            }
        }
        .padding([.horizontal, .bottom], 10)
    }
}

#Preview {
    SettingsRowComponent(title: "Tags",subtitle: "Lets just see",image: "number", color: .blue, isDropDown: .constant(15), dropDownVariations: [5,10,15,20])
}
