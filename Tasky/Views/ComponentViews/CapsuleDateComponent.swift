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
    
    let day: Date
    
    var colorTheme: Color {
        settingsMangerVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var isItCurrentDay: Bool {
        day.getDayDigit == calendarSet.currentDay.getDayDigit
    }
    
    var body: some View {
        VStack{
            ZStack{
                Capsule()
                    .stroke(Color.gray, lineWidth: 1)
                    .background(isItCurrentDay ? colorTheme : Color.clear, in:.capsule)
                    .frame(height: 90)
                    .frame(width: 50)
                    .foregroundStyle(.clear)
                Text("\(day.getDayDigit)")
                    .font(.system(.headline, design: .rounded, weight: isItCurrentDay ? .bold : .regular))
                    .foregroundStyle(isItCurrentDay ? .white : .black)
            }
            Text(day.getWeekName.prefix(3).capitalized)
                .font(.system(.headline, design: .rounded, weight: isItCurrentDay ? .semibold : .regular))
        }
    }
}

#Preview {
    CapsuleDateComponent(settingsMangerVM: MockPreviews.viewModel, day: .now)
}
