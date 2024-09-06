//
//  YourTasksComponentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct YourTodosComponentView: View {
    @State var isShowingActive: Bool = true
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    @Binding var path: NavigationPath
    var body: some View {
        VStack{
            GeometryReader{ geo in
                let minY = geo.frame(in: .global).minY
                let progress = max(min( -minY / 70, 1), 0)
                HStack{
                    Text("\(isShowingActive ? "Active" : "Done") Todos")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    Spacer()
                    Button{
                        withAnimation {
                            isShowingActive = true
                        }
                    } label:{
                        Capsule()
                            .stroke(colorTheme, lineWidth: 2)
                            .background(isShowingActive ? colorTheme : .clear, in: .capsule)
                            .frame(width: 80, height: 40)
                            .overlay{
                                Text("Active")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(isShowingActive ? .white : colorTheme)
                                    .frame(width: 80, height: 40)
                            }
                    }
                    Button{
                        withAnimation {
                            isShowingActive = false
                        }
                    } label:{
                        Capsule()
                            .stroke(colorTheme, lineWidth: 2)
                            .background(!isShowingActive ? colorTheme : .clear, in: .capsule)
                            .frame(width: 80, height: 40)
                            .overlay{
                                Text("Done")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(!isShowingActive ? .white : colorTheme)
                                    .frame(width: 80, height: 40)
                            }
                    }
                }
                .background{
                    Rectangle()
                        .fill(Constants.backgroundColor)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 8)
                }
                .background(ignoresSafeAreaEdges: .top)
                .offset(y: max(45 - minY, 0))
            }
            .frame(height: 50)
            .zIndex(1)
            
            TodoListView(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM: tagVM, path: $path, isShowingActive: $isShowingActive)
                .zIndex(0)
        }
    }
}

#Preview {
    YourTodosComponentView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
}
