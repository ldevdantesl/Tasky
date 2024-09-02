//
//  CapsuleDateComponent.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct CapsuleDateComponent: View {
    @ObservedObject var settingsMangerVM: SettingsManagerViewModel
    @Environment(\.colorScheme) var systemColorScheme
    let calendarSet = CalendarSet.instance
    let day: Day
    var colorScheme: ColorScheme {
        settingsMangerVM.settingsManager.appearanceSettingsManager.colorScheme ?? systemColorScheme
    }
    var body: some View {
        VStack{
            ZStack{
                Capsule()
                    .stroke(Color.gray, lineWidth: 1)
                    .background(day.number == calendarSet.currentDayNumber ? .linearGradient(colors: [.blue, .orange], startPoint: .top, endPoint: .bottom) : .linearGradient(colors: colorScheme == .light ? [.white] : [.black], startPoint: .top, endPoint: .bottom), in:.capsule)
                    .frame(height: 90)
                    .frame(width: 50)
                    .foregroundStyle(.clear)
                Text(day.number)
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(day.number == calendarSet.currentDayNumber || colorScheme == .dark ? .white : .black)
            }
            Text(day.name.prefix(3).capitalized)
                .font(.system(.headline, design: .rounded, weight: .semibold))
        }
    }
}

#Preview {
    CapsuleDateComponent(settingsMangerVM: MockPreviews.viewModel, day: Day(number: "22", name: "Wednesday"))
}
