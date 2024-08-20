//
//  PriorityCapsuleView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import SwiftUI

struct PriorityCapsuleView: View {
    @Binding var selectedPriority: Int16
    var body: some View {
        VStack(alignment:.leading){
            Text("Priority of your task")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal,5)
                .padding(.vertical,10)
            HStack{
                Button(action:{}){
                    filterButton(text: "Trivial")
                }
                Button(action:{}){
                    filterButton(text: "Fair")
                }
                Button(action:{}){
                    filterButton(text: "Principal")
                }
                
            }
        }
    }
    
    @ViewBuilder
    func filterButton(text:String) -> some View{
        var color: Color {
            switch text{
            case "Trivial":
                return Color.green
            case "Fair":
                return Color.blue
            default:
                return Color.red
            }
        }
        
        var priority: Int16 {
            switch text{
            case "Trivial":
                return 1
            case "Fair":
                return 2
            default:
                return 3
            }
        }
        
        Button{
            withAnimation {
                selectedPriority = priority
            }
        } label: {
            VStack{
                Text(text)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: Constants.screenWidth / 3 - 20)
                    .frame(minHeight: 40)
                    .frame(maxHeight: 40)
                    .background(color, in: .capsule)
                if selectedPriority == priority{
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 20)
                        .frame(maxHeight: 20)
                        .foregroundStyle(color)
                    
                }
            }
        }
    }
}

#Preview {
    PriorityCapsuleView(selectedPriority: .constant(1))
}
