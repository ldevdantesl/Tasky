//
//  CalendarComponentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import SwiftUI

struct CapsuleWeekStackComponent: View {
    @ObservedObject var settingsManagerVM: SettingsManagerViewModel
    @ObservedObject var calendar = CalendarSet.instance
    
    var currentWeek: [Date]{
        calendar.getCurrentWeek()
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing:0){
                ForEach(currentWeek, id: \.self) { day in
                    CapsuleDateComponent(settingsMangerVM: settingsManagerVM, day: day)
                        .padding(.horizontal,10)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                calendar.currentDay = day
                            }
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    CapsuleWeekStackComponent(settingsManagerVM: MockPreviews.viewModel)
}
