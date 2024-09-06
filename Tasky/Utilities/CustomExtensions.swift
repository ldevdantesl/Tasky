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
        return dateFormatter.string(from: self)
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
    
    var getDayAndMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM" // Format: Day and full month (e.g., "1 September")
        return dateFormatter.string(from: self)
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
