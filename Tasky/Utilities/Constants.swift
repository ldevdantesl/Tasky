//
//  Constants.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 19.08.2024.
//

import Foundation
import SwiftUI

public enum Constants{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    static let secondaryColor = Color.secondary.opacity(0.2)
    static let circularShape: RoundedRectangle = .rect(cornerRadius: 15)
}

public func log(_ message: String){
    print(message)
}

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

func areColorsEqual(color1: Color?, color2: Color) -> Bool {
    guard let color1 = color1 else { return false }
    
    let uiColor1 = UIColor(color1)
    let uiColor2 = UIColor(color2)
    
    var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
    var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
    
    uiColor1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
    uiColor2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
    
    return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
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
