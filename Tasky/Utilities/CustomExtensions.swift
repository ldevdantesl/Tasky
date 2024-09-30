//
//  CustomExtensions.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 4.09.2024.
//

import Foundation
import SwiftUI

extension Color {
    func toData() -> Data? {
        let uiColor = UIColor(self)
        return try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
    }
    
    static func fromData(_ data: Data) -> Color? {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        }
        return nil
    }
}

extension ColorScheme{
    func name() -> String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        default:
            return "System"
        }
    }
}

extension Date {
    
    var getTomorrowDay: Date {
        var dateComponent = DateComponents()
        dateComponent.day = 1
        return Calendar.current.date(byAdding: dateComponent, to: self)!
    }
    
    var getDayDigit: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return Int(dateFormatter.string(from: self))!
    }
    
    var getWeekName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    var getDayMonthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    var getDayMonthInt: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return Int(dateFormatter.string(from: self))!
    }
    
    var getYear: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        return String(year)
    }
    
    var getHourInt: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return components.hour ?? 0
    }
    
    var getTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // Set the format to 24-hour time, e.g., "21:00"
        return formatter.string(from: self)
    }
    
    var asStartOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var isStartOfDay: Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self)
        return components.hour == 0 && components.minute == 0 && components.second == 0
    }
    
    var getDayAndMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM" // Format: Day and full month (e.g., "1 September")
        return dateFormatter.string(from: self).capitalized
    }
    
    static func getEveryMonths(startingFrom month: Int, locale: String) -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        
        // Set the locale for month formatting
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        
        // Get the current year
        let year = calendar.component(.year, from: Date())
        
        // Loop through the months starting from the given month number
        for offset in 0..<12 {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = (month + offset - 1) % 12 + 1 // Adjust month number to loop through the year
            
            // If the month overflows into the next year, increment the year
            if (month + offset) > 12 {
                dateComponents.year = year + 1
            }
            
            // Get the first day of the month as a Date
            if let firstDayOfMonth = calendar.date(from: dateComponents) {
                dates.append(firstDayOfMonth)
            }
        }
        
        return dates
    }
}

