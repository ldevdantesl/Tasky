//
//  TabBarsComponents.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct TabBarsComponent: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @Binding var path: NavigationPath
    
    var isSelectedHome: Bool {
        path.isEmpty
    }
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        HStack(spacing:0){
            Button{
                withAnimation {
                    path.removeLast(path.count)
                }
            } label: {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .frame(height: 65)
                    .frame(minWidth: Constants.screenWidth / 3 + 10)
                    .overlay(alignment:.leading) {
                        HStack{
                            Circle()
                                .fill(isSelectedHome ? colorTheme : .gray.opacity(0.4))
                                .frame(width: 55, height: 55)
                                .overlay{
                                    Image(systemName: "house")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(isSelectedHome ? .white : .black.opacity(0.7))
                                }
                                .padding(.leading, 5)
                            Text("Home")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.8))
                                .padding(.trailing, 10)
                        }
                    }
            }
            Button{
                withAnimation {
                    path.append("AddTodoView")
                }
            } label: {
                Circle()
                    .fill(colorTheme)
                    .frame(width: 55,height: 55)
                    .overlay{
                        Text("+")
                            .font(.system(.title, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 5)
            }
            
            Button{
                withAnimation {
                    path.append("SettingsView")
                }
            } label: {
                Capsule()
                    .fill(.ultraThinMaterial)
                    .frame(height: 65)
                    .frame(minWidth: Constants.screenWidth / 3 + 10)
                    .overlay(alignment:.trailing) {
                        HStack{
                            Text("Settings")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.8))
                            
                            Circle()
                                .fill(!isSelectedHome ? colorTheme : .gray.opacity(0.4))
                                .frame(width: 55, height: 55)
                                .overlay{
                                    Image(systemName: "gear")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(!isSelectedHome ? .white : .black.opacity(0.7))
                                }
                                .padding(.trailing, 5)
                        }
                    }
            }
            .disabled(path.count > 0)
        }
        .padding(.horizontal,10)
        .navigationDestination(for: String.self) { view in
            if view == "SettingsView"{
                SettingsView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
                    .toolbar(.hidden, for: .navigationBar)
            } else {
                AddTodoView(todoVM: todoVM, tagVM: tagVM, settingsMgrVM: settingsMgrVM, path: $path)
            }
        }
    }
}

#Preview {
    TabBarsComponent(settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel(), path: .constant(NavigationPath()))
}
