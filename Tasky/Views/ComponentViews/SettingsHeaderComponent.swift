//
//  SettingsHeaderComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 6.09.2024.
//

import SwiftUI

struct SettingsHeaderComponent: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @Binding var path: NavigationPath
    
    let title: String
    var buttonItems: [ButtonItem]?
    let showingBackButton: Bool
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    init(settingsMgrVM: SettingsManagerViewModel, path: Binding<NavigationPath>, title: String, buttonItems: [ButtonItem]? = nil, showingBackButton: Bool = true) {
        self.settingsMgrVM = settingsMgrVM
        self._path = path
        self.title = title
        self.buttonItems = buttonItems
        self.showingBackButton = showingBackButton
        self.buttonItems = buttonItems
    }
    
    var body: some View {
        HStack{
            if showingBackButton{
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(colorTheme)
                    .onTapGesture {
                        path.removeLast()
                    }
            }
            Text(title)
                .font(.system(.title, design: .rounded, weight: .bold))
            
            Spacer()
            if let buttonItems{
                ForEach(0..<buttonItems.count, id: \.self) { index in
                    Button(action: buttonItems[index].action) {
                        Image(systemName: buttonItems[index].systemImage)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(buttonItems[index].color)
                            .frame(width: 25, height: 25)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsHeaderComponent(settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()), title: "Tags")
}
