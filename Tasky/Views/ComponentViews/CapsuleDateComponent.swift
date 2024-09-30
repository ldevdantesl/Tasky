//
//  CapsuleDateComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct CapsuleDateComponent: View {
    @ObservedObject var settingsMangerVM: SettingsManagerViewModel
    @ObservedObject var calendarSet = CalendarSet.instance
    
    let isSmall: Bool
    let day: Date
    
    var colorTheme: Color {
        settingsMangerVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var isItCurrentDay: Bool {
        day.getDayDigit == calendarSet.currentDay.getDayDigit && day.getDayMonthInt == calendarSet.currentDay.getDayMonthInt
    }
    
    var body: some View {
        VStack{
            Capsule()
                .stroke(Color.gray, lineWidth: isItCurrentDay ? 0 : 1)
                .background(isItCurrentDay ? colorTheme : Color.background, in:.capsule)
                .frame(width: 50, height: isSmall ? 70 : 90)
                .foregroundStyle(.clear)
                .overlay{
                    Text("\(day.getDayDigit)")
                        .font(.system(.headline, design: .rounded, weight: isItCurrentDay ? .bold : .regular))
                        .foregroundStyle(isItCurrentDay ? .white : .primary)
                }
            
            Text(day.getWeekName.prefix(3).capitalized)
                .font(.system(.headline, design: .rounded, weight: isItCurrentDay ? .semibold : .regular))
        }
    }
}

#Preview {
    CapsuleDateComponent(settingsMangerVM: MockPreviews.viewModel, isSmall: true, day: .now)
}
