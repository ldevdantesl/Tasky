//
//  CalendarSet.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import Foundation

class CalendarSet: ObservableObject{
    
    static let instance = CalendarSet()
    
    @Published var currentDay: Date = .now
    
    func getCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        let today = Date()

        // Get the current weekday index
        let weekdayIndex = calendar.component(.weekday, from: today)

        // Find the start of the week
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekdayIndex - calendar.firstWeekday), to: today)!

        var currentWeekDates: [Date] = []

        // Get each date in the current week
        for i in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                currentWeekDates.append(weekDay)
            }
        }

        return currentWeekDates
    }
}
