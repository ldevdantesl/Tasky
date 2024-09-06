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
    @Binding var showingWholeMonth: Bool
    @Binding var selectedMonth: String
    
    let columns = Array(repeating: GridItem(.fixed(45), spacing: 10), count: 7)
    
    var colorTheme: Color {
        settingsManagerVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var currentWeek: [Date]{
        calendar.getCurrentWeek()
    }
    
    var currentMonth: [Date] {
        calendar.getWholeMonth(for: selectedMonth) ?? []
    }
    
    var body: some View {
        if !showingWholeMonth{
            ScrollView(.horizontal) {
                LazyHStack(spacing:0){
                    ForEach(currentWeek, id: \.self) { day in
                        CapsuleDateComponent(settingsMangerVM: settingsManagerVM, isSmall: false, day: day)
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
            .frame(height: 130)
        } else {
            LazyVGrid(columns: columns){
                ForEach(currentMonth, id: \.self){ day in
                    CapsuleDateComponent(settingsMangerVM: settingsManagerVM, isSmall: true, day: day)
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                calendar.currentDay = day
                                showingWholeMonth = false
                            }
                        }
                }
                Capsule()
                    .stroke(Color.gray, lineWidth: 1)
                    .background(colorTheme, in:.capsule)
                    .frame(width: 50, height: 70)
                    .foregroundStyle(colorTheme)
                    .overlay{
                        VStack{
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                            Text("Go to Today")
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                .multilineTextAlignment(.center)
                        }
                        .foregroundStyle(.white)
                    }
                    .padding(.bottom, 25)
                    .onTapGesture {
                        withAnimation {
                            selectedMonth = Date.now.getDayMonthString
                            calendar.currentDay = .now
                            showingWholeMonth = false
                        }
                    }
            }
        }
    }
}

#Preview {
    CapsuleWeekStackComponent(settingsManagerVM: MockPreviews.viewModel, showingWholeMonth: .constant(true), selectedMonth: .constant("January"))
}
