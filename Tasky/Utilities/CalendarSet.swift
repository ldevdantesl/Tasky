//
//  CalendarSet.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import Foundation

struct Day{
    let number:String
    let name: String
    var id: String {number + name}
}

class CalendarSet {
    
    static let instance = CalendarSet()
    
    var currentDayNumber: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: .now)
    }
    
    var currentDayName: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: .now)
    }
    
    func getCurrentWeek() -> [Day] {
        let calendar = Calendar.current
        let today = Date()
        let weekDay = calendar.component(.weekday, from: today)
        
        // Calculate how many days from the start of the week
        let daysFromWeekStart = -(weekDay - calendar.firstWeekday) % 7
        
        let dayNameFormatter = DateFormatter()
        dayNameFormatter.dateFormat = "EEEE"  // Format for full weekday name
        
        let dayNumberFormatter = DateFormatter()
        dayNumberFormatter.dateFormat = "dd"  // Format for day of the month
        
        var days: [Day] = []
        
        // Compute the start of the week date
        if let startOfWeek = calendar.date(byAdding: .day, value: daysFromWeekStart, to: today) {
            for dayOffset in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                    let name = dayNameFormatter.string(from: date)
                    let number = dayNumberFormatter.string(from: date)
                    let day = Day(number: number, name: name)
                    days.append(day)
                }
            }
        }
        
        return days
    }
}
