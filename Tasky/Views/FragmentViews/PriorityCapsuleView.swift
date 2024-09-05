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
            Text("Priority")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(Constants.secondaryColor)
                
            HStack{
                filterButton(text: "trivial_key")
                    .shadow(color: .black.opacity(selectedPriority == 1 ? 0.2 : 0), radius: 10, x: 0, y: 5)
                filterButton(text: "fair_key")
                    .shadow(color: .black.opacity(selectedPriority == 2 ? 0.2 : 0), radius: 10, x: 0, y: 5)
                filterButton(text: "principal_key")
                    .shadow(color: .black.opacity(selectedPriority == 3 ? 0.2 : 0), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    @ViewBuilder
    func filterButton(text:LocalizedStringKey) -> some View{
        var color: Color {
            switch text{
            case "trivial_key":
                return Color.green
            case "fair_key":
                return Color.blue
            default:
                return Color.red
            }
        }
        
        var priority: Int16 {
            switch text{
            case "trivial_key":
                return 1
            case "fair_key":
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
