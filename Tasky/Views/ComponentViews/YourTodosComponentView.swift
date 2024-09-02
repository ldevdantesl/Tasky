//
//  YourTasksComponentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct YourTodosComponentView: View {
    @State var isShowingActive: Bool = false
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var tagVM: TagViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var path: NavigationPath
    var body: some View {
        VStack{
            HStack{
                Text("Your Todos")
                    .font(.system(.title, design: .rounded, weight: .bold))
                Spacer()
                Button{
                    withAnimation {
                        isShowingActive = true
                    }
                } label:{
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green, lineWidth: 2)
                            .background(isShowingActive ? .green : .clear, in:.capsule)
                            .frame(width: 80, height: 40)
                        Text("Active")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(isShowingActive ? .white : .green)
                            .frame(width: 80, height: 40)
                    }
                }
                Button{
                    withAnimation {
                        isShowingActive = false
                    }
                } label:{
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.green, lineWidth: 2)
                            .background(!isShowingActive ? .green : .clear, in: .capsule)
                            .frame(width: 80, height: 40)
                        Text("Done")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(!isShowingActive ? .white : .green)
                            .frame(width: 80, height: 40)
                    }
                }
            }
            TodoListView(settingsMgrVM: settingsMgrVM, todoVM: todoVM, tagVM: tagVM, path: $path, isShowingActive: $isShowingActive)
        }
    }
}

#Preview {
    YourTodosComponentView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel, path: .constant(NavigationPath()))
}
