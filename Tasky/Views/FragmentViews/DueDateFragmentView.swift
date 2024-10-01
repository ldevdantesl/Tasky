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
    @State var isAddingTime: Bool = false
    @State var isPickingCustomDate: Bool = false
    @State var isPickingCustomTime: Bool = false
    @State var settingDate: Date = .now
    @State var settingTime: Date = .now

    var showDate: String {
        var returningDate = ""
        if let dueDate{
            returningDate += String("\(dueDate.getDayDigit) ")
            returningDate += "\(dueDate.getDayMonthString) "
            if !dueDate.isStartOfDay{
                returningDate += "at \(dueDate.getTime)"
            }
        }
        return returningDate
    }
    
    var themeColor: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var timeVariations: [Int] {
        var variations: [Int] = []
        var range = 1...23
        if dueDate != nil, isItToday() {
            range = Date().getHourInt+1...23
        }
        for i in range {
            variations.append(i)
        }
        return variations
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            
            HStack(spacing: 0){
                Text("Date: ")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(.customSecondary)
                
                if let dateErrorMessage = dateErrorMessage, dueDate == nil {
                    Text(dateErrorMessage)
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.red.opacity(0.8))
                } else {
                    Text(showDate)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundColor(.text)
                }
            }
            .padding(.horizontal, 20)
            
            HStack{
                
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
                .foregroundStyle(dueDate == nil ? .text : .white)
                .frame(width: 80, height: 45)
                .background(dueDate == nil ? .textField : themeColor, in:.capsule)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        isAddingDate.toggle()
                        isAddingTime = false
                    }
                }
                
                if isAddingDate {
                    VStack(spacing: 0){
                        Image(systemName: "sun.and.horizon.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(isItToday() ? .white : .secondary)
                        Text("Today")
                            .font(.system(.subheadline, design: .rounded, weight: isItToday() ? .semibold : .regular))
                            .foregroundColor(isItToday() ? .white : .text)
                    }
                    .frame(width: 85, height: 45)
                    .background(isItToday() ? themeColor : .textField, in: .capsule)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                            guard let today = Calendar.current.date(from: todayComponents) else { return }
                            dueDate = today
                            isAddingDate = false
                            logger.log("\(dueDate!), Today: \(isItToday()), Tomorrow: \(isItTomorrow())")
                        }
                    }
                    
                    VStack(spacing: 0){
                        Image(systemName: "clock.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 20)
                            .foregroundStyle(isItTomorrow() ? .white : .secondary)
                        Text("Tomorrow")
                            .font(.system(.subheadline, design: .rounded, weight: isItTomorrow() ? .semibold : .regular))
                            .foregroundColor(isItTomorrow() ? .white : .text)
                    }
                    .frame(width: 90, height: 45)
                    .background(isItTomorrow() ? themeColor : .textField, in:.capsule)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date().getTomorrowDay)
                            guard let tomorrow = Calendar.current.date(from: tomorrowComponents) else { return }
                            dueDate = tomorrow
                            isAddingDate = false
                        }
                    }
                    
                    VStack(spacing: 0){
                        Image(systemName: "calendar.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(isItNotTomorrowAndNotToday() ? .white : .customSecondary)
                            .padding(.leading, 3)
                        Text("Custom")
                            .font(.system(.subheadline, design: .rounded, weight: isItNotTomorrowAndNotToday() ? .semibold : .regular))
                            .foregroundColor(isItNotTomorrowAndNotToday() ? .white : .text)
                    }
                    .frame(width: 90, height: 45)
                    .background(isItNotTomorrowAndNotToday() ? themeColor : .textField, in: .capsule)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            isPickingCustomDate.toggle()
                        }
                    }
                    
                }
                
                else if !isAddingDate && dueDate != nil {
                    HStack{
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 24, maxHeight: 24)
                        
                        Image(systemName: isAddingTime ? "chevron.up" : "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 15, maxHeight: 15)
                    }
                    .foregroundStyle(dueDate!.isStartOfDay ? .text : .white)
                    .frame(width: 80, height: 45)
                    .background(dueDate!.isStartOfDay ? .textField : themeColor, in: .capsule)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            isAddingTime.toggle()
                        }
                    }
                }
                Spacer()
            }
            .frame(width: Constants.screenWidth - 40, height: 50)
            .padding(.horizontal, 20)
            
            if isAddingTime{
                ScrollView(.horizontal){
                    LazyHStack(spacing: 10){
                        if !dueDate!.isStartOfDay{
                            Button{
                                withAnimation {
                                    dueDate = dueDate?.asStartOfDay
                                }
                            } label: {
                                Text("No time")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 80, height: 40)
                                    .background(themeColor, in:.capsule)
                            }
                        }
                        
                        Button(action: {isPickingCustomTime.toggle()}){
                            Text("Custom")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 80, height: 40)
                                .background(themeColor, in:.capsule)
                        }
                        
                        ForEach(timeVariations, id: \.self){ variation in
                            Button{
                                var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate!)
                                components.hour = variation
                                components.minute = 0
                                withAnimation {
                                    dueDate = Calendar.current.date(from: components)
                                    isAddingTime.toggle()
                                }
                                
                            } label: {
                                Text("\(variation):00")
                                    .font(.system(.headline, design: .rounded, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 70, height: 40)
                                    .background(themeColor, in:.capsule)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
                .frame(height: 50)
            }
        }
        .sheet(isPresented: $isPickingCustomDate){
            VStack {
                // DatePicker inside a sheet
                DatePicker(
                    "Select a Date",
                    selection: $settingDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical) // Or use another style like .wheel, .compact, etc.
                .labelsHidden() // Hide the default label
                .padding()
                
                Button("Done") {
                    withAnimation {
                        let customComponents = Calendar.current.dateComponents([.year, .month, .day], from: settingDate)
                        guard let customDay = Calendar.current.date(from: customComponents) else { return }
                        dueDate = customDay
                        isPickingCustomDate.toggle()
                        isAddingDate = false
                    }
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isPickingCustomTime) {
            VStack {
                var todayStart: Date {
                    if dueDate?.asStartOfDay != Date.now.asStartOfDay{
                        return Calendar.current.startOfDay(for: dueDate!)
                    } else {
                        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: dueDate!)
                        return Calendar.current.date(from: dateComponents) ?? dueDate!
                    }
                }
                    
                let todayEnd: Date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: todayStart) ?? Date()
                
                // DatePicker inside a sheet
                DatePicker(
                    "Select a Time",
                    selection: $settingTime,
                    in: todayStart...todayEnd,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel) // Or use another style like .wheel, .compact, etc.
                .labelsHidden() // Hide the default label
                .padding()
                
                Button("Done") {
                    withAnimation {
                        let customComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: settingTime)
                        guard let customTime = Calendar.current.date(from: customComponents) else { return }
                        dueDate = customTime
                        isPickingCustomTime.toggle()
                        isAddingTime = false
                    }
                }
                .padding()
            }
            .presentationDetents([.medium])
        }
    }
    
    func isItNotTomorrowAndNotToday() -> Bool {
        return !isItTomorrow() && !isItToday() && dueDate != nil
    }
    
    func isItToday() -> Bool {
        return dueDate?.asStartOfDay == Date.now.asStartOfDay
    }
    
    func isItTomorrow() -> Bool {
        return dueDate?.asStartOfDay == Date.now.getTomorrowDay.asStartOfDay
    }
}

#Preview {
    DueDateFragmentView(settingsMgrVM: MockPreviews.viewModel, dueDate: .constant(.now.getTomorrowDay), dateErrorMessage: .constant(nil))
}
