//
//  DueDateFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 20.08.2024.
//

import SwiftUI

struct DueDateFragmentView: View {
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    
    @Binding var dueDate: Date?
    @Binding var dateErrorMessage: String?
    @State var isAddingDate: Bool = false
    @State var isPickingCustomDate: Bool = false
    @State var settingDate: Date = .now

    var showDate: String {
        if let dueDate{
            return "\(String(dueDate.getDayDigit)) \(dueDate.getDayMonth)"
        } else {
            return ""
        }
    }
    
    var themeColor: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack(spacing: 0){
                Text("Date: ")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(Constants.secondaryColor)
                
                if let dateErrorMessage = dateErrorMessage, dueDate == nil{
                    Text(dateErrorMessage)
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.red.opacity(0.8))
                } else {
                    Text(showDate)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundColor(Constants.textColor)
                }
            }
            
            HStack{
                Capsule()
                    .fill(dueDate == nil ? Constants.textFieldColor : themeColor)
                    .frame(minWidth: 70, maxWidth: 80)
                    .frame(height: 45)
                    .overlay{
                        HStack{
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 24, maxHeight: 24)
                            
                            Image(systemName: isAddingDate ? "chevron.left" : "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 15, maxHeight: 15)
                        }
                        .foregroundStyle(dueDate == nil ? Constants.textColor : .white)
                    }
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            isAddingDate.toggle()
                        }
                    }
                
                if isAddingDate{
                    Capsule()
                        .fill(dueDate?.getDayDigit == Date.now.getDayDigit ? themeColor : Constants.textFieldColor)
                        .frame(minWidth: 80, maxWidth: 85)
                        .frame(height: 45)
                        .overlay{
                            Text("Today")
                                .font(.system(.headline, design: .rounded, weight: dueDate?.getDayDigit == Date.now.getDayDigit ? .semibold : .regular))
                                .foregroundColor(dueDate?.getDayDigit == Date.now.getDayDigit ? .white : Constants.textColor)
                        }
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                dueDate = .now
                                isAddingDate = false
                            }
                        }
                    
                    Capsule()
                        .fill(dueDate?.getDayDigit == Date.now.getDayDigit + 1 ? themeColor : Constants.textFieldColor)
                        .frame(minWidth: 80, maxWidth: 85)
                        .frame(height: 45)
                        .overlay{
                            Text("Tomorrow")
                                .font(.system(.headline, design: .rounded, weight: dueDate?.getDayDigit == Date.now.getDayDigit + 1 ? .semibold : .regular))
                                .foregroundColor(dueDate?.getDayDigit == Date.now.getDayDigit + 1 ? .white : Constants.textColor)
                        }
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                dueDate = Calendar.current.date(byAdding: .day, value: 1, to: .now)
                                isAddingDate = false
                            }
                        }
                    
                    Button(action: {isPickingCustomDate.toggle()}){
                        Capsule()
                            .fill(dueDate?.getDayDigit != Date.now.getDayDigit + 1 && dueDate?.getDayDigit != Date.now.getDayDigit && dueDate != nil ? themeColor : Constants.textFieldColor)
                            .frame(minWidth: 70, maxWidth: 90)
                            .frame(height: 45)
                            .overlay{
                                Text("Custom")
                                    .font(.system(.headline, design: .rounded, weight: dueDate?.getDayDigit != Date.now.getDayDigit + 1 && dueDate?.getDayDigit != Date.now.getDayDigit && dueDate != nil ? .semibold : .regular))
                                    .foregroundColor(dueDate?.getDayDigit != Date.now.getDayDigit + 1 && dueDate?.getDayDigit != Date.now.getDayDigit && dueDate != nil ? .white : Constants.textColor)
                            }
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    isPickingCustomDate.toggle()
                                }
                            }
                    }
                }
                else {
                    Spacer()
                        .frame(width: Constants.screenWidth - 120)
                }
            }
        }
        .sheet(isPresented: $isPickingCustomDate){
            VStack {
                // DatePicker inside a sheet
                DatePicker(
                    "Select a Date",
                    selection: $settingDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical) // Or use another style like .wheel, .compact, etc.
                .labelsHidden() // Hide the default label
                .padding()
                
                Button("Done") {
                    withAnimation {
                        dueDate = settingDate
                        isPickingCustomDate.toggle()
                        isAddingDate = false
                    }
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    DueDateFragmentView(settingsMgrVM: MockPreviews.viewModel, dueDate: .constant(.now), dateErrorMessage: .constant(nil))
}
