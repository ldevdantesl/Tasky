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
    
    var body: some View {
        HStack(spacing:0){
            Button{
                
            } label:{
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 45)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 65)
                        .frame(minWidth: Constants.screenWidth / 3 + 10)
                    HStack{
                        ZStack{
                            Circle()
                                .fill()
                                .frame(width: 55, height: 55)
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.black.opacity(0.8))
                        }
                        .padding(.leading, 5)
                        Text("Home")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.8))
                    }
                }
            }
            
            NavigationLink(destination: AddTodoView(todoVM:todoVM, tagVM: tagVM)){
                ZStack{
                    Circle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: 60,height: 60)
                    Circle()
                        .fill(.green)
                        .frame(width: 55,height: 55)
                    Text("+")
                        .font(.system(.title, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            
            Button{
                
            } label:{
                ZStack(alignment:.trailing){
                    RoundedRectangle(cornerRadius: 45)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 65)
                        .frame(minWidth: Constants.screenWidth / 3 + 10)
                    HStack{
                        Text("Stats")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(.black.opacity(0.8))
                            .padding(.trailing, 10)
                        ZStack{
                            Circle()
                                .fill()
                                .frame(width: 55, height: 55)
                            Image(systemName: "chart.bar.xaxis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black.opacity(0.7))
                        }
                        .padding(.trailing,5)
                    }
                }
            }
            
        }
        .padding(.horizontal,10)
    }
}

#Preview {
    TabBarsComponent(settingsMgrVM: MockPreviews.viewModel, todoVM: TodoViewModel(), tagVM: TagViewModel())
}
