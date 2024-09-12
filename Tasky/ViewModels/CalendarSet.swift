//
//  CalendarSet.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.09.2024.
//

import Foundation
import SwiftUI

class CalendarSet: ObservableObject{
    
    static let instance = CalendarSet()
    
    @Published var currentDay: Date = .now
    
    func getCurrentWeek() -> [Date] {
        let calendar = Calendar.current
        
        // Get the current weekday index
        let weekdayIndex = calendar.component(.weekday, from: currentDay)

        // Find the start of the week
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekdayIndex - calendar.firstWeekday), to: currentDay)!

        var currentWeekDates: [Date] = []

        // Get each date in the current week
        for i in 0..<7 {
            if let weekDay = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                currentWeekDates.append(weekDay)
            }
        }

        return currentWeekDates
    }
    
    func getWholeMonth(for monthName: String, locale: String = "en_US") -> [Date]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Full month name format
        dateFormatter.locale = Locale(identifier: locale)
        
        // Convert month name to a Date
        if let monthDate = dateFormatter.date(from: monthName) {
            let calendar = Calendar.current
            
            // Get the current year from the current date
            let currentYear = calendar.component(.year, from: currentDay)
            
            // Get the month number from the monthDate
            let monthNumber = calendar.component(.month, from: monthDate)
            
            // Create DateComponents for the desired month and year
            var components = DateComponents()
            components.year = currentYear
            components.month = monthNumber
            
            // Get the first day of the month
            guard let firstOfMonth = calendar.date(from: components),
                  let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
                return nil // Return nil if date creation fails
            }
            
            // Create an array of dates for the whole month
            let dates = range.compactMap { day -> Date? in
                var dateComponents = DateComponents()
                dateComponents.year = currentYear
                dateComponents.month = monthNumber
                dateComponents.day = day
                return calendar.date(from: dateComponents)
            }
            
            return dates
        }
        
        return nil // Return nil if the month name is invalid
    }
    
    func returnToToday() {
        currentDay = .now
    }
    
    func showHowManyDaysLeft(for futureDate: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard futureDate.getDayAndMonth != currentDate.getDayAndMonth else {
            return "Today"
        }
        
        // Ensure the future date is indeed in the future
        guard futureDate > currentDate else {
            return "The date has passed"
        }
        
        // Calculate the difference in components (days, months, years)
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate, to: futureDate)
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year left" : "\(years) years left"
        } else if let months = components.month, months > 0 {
            return months == 1 ? "1 month left" : "\(months) months left"
        }else if let days = components.day, days > 0 {
            return days == 1 ? "1 day left" : "\(days) days left"
        } else {
            return "Less than a day left"
        }
    }
}
