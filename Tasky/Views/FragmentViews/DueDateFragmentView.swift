//
//  DueDateFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 20.08.2024.
//

import SwiftUI

struct DueDateFragmentView: View {
    @Binding var dueDate: Date
    @Binding var addDueDate: Bool
    var body: some View {
        if !addDueDate{
            HStack{
                Text("Add Due Date")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
                    
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20)
                    .frame(maxHeight: 20)
                    .foregroundStyle(.blue)
                Spacer()
            }
            .padding(.horizontal,10)
            .onTapGesture {
                withAnimation {
                    addDueDate.toggle()
                }
            }
        } else {
            HStack{
                DatePicker(selection: $dueDate, displayedComponents: [.date,.hourAndMinute]) {
                    Text("Due Date: ")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal,5)
                }
                .padding(.horizontal, 10)
                Button("", systemImage: "xmark.circle.fill"){
                    withAnimation {
                        addDueDate.toggle()
                    }
                }
                .font(.title3)
                .tint(.red)
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    DueDateFragmentView(dueDate: .constant(.now), addDueDate: .constant(false))
}
