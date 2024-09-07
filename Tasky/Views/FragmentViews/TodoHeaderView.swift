//
//  TodoHeaderView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 6.09.2024.
//

import SwiftUI

struct TodoHeaderView: View {
    @ObservedObject var todoVM: TodoViewModel
    @ObservedObject var settingsMgrVM: SettingsManagerViewModel
    @ObservedObject var calendar = CalendarSet.instance
    
    @Binding var showingWholeMonth: Bool
    @Binding var selectedMonth: String
    
    var colorTheme: Color {
        settingsMgrVM.settingsManager.appearanceSettingsManager.colorTheme
    }
    
    var body: some View {
        HStack{
            if !showingWholeMonth{
                Text("\(calendar.currentDay.getWeekName.capitalized), \(calendar.currentDay.getDayDigit) \(String(calendar.currentDay.getDayMonthString.prefix(3)))")
                    .font(.system(.title, design: .rounded, weight: .bold))
            } else {
                Menu{
                    ForEach(Date.getEveryMonths(startingFrom: Date().getDayMonthInt, locale: settingsMgrVM.currentLanguage), id:\.self) { date in
                        Button(action: {selectedMonth = date.getDayMonthString}){
                            Text("\(date.getDayMonthString) \(Date.now.getYear != date.getYear ? date.getYear : "")")
                        }
                    }
                } label: {
                    HStack{
                        Text("\(selectedMonth)")
                            .font(.system(.title, design: .rounded, weight: .bold))
                        Image(systemName: "chevron.up.chevron.down")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 15, height: 15)
                    }
                }
            }
            
            Spacer()
            
            if calendar.currentDay.getDayAndMonth != Date.now.getDayAndMonth && !showingWholeMonth{
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 20)
                    .foregroundStyle(colorTheme)
                    .onTapGesture {
                        withAnimation {
                            calendar.returnToToday()
                            selectedMonth = calendar.currentDay.getDayMonthString
                        }
                    }
                    .padding(.trailing, 10)
            }
            
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 20)
                .foregroundStyle(colorTheme)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        showingWholeMonth.toggle()
                    }
                }
        }
            
    }
}

#Preview {
    TodoView(todoVM: TodoViewModel(), tagVM: TagViewModel(), settingsMgrVM: MockPreviews.viewModel)
}
