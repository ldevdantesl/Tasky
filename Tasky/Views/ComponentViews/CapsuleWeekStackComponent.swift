//
//  CalendarComponentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct CapsuleWeekStackComponent: View {
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    let calendar = CalendarSet.instance
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing:0){
                ForEach(calendar.getCurrentWeek(), id: \.id) {day in
                    CapsuleDateComponent(settingsMangerVM: settingsManagerVM, day: day)
                        .padding(.horizontal,10)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    CapsuleWeekStackComponent(settingsManagerVM: MockPreviews.viewModel)
}
