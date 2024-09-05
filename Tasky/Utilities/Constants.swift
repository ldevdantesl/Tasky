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
    static let circularShape: RoundedRectangle = .rect(cornerRadius: 15)
    static let backgroundColor: Color = Color("backgroundColor")
    static let secondaryColor: Color = Color("customSecondaryColor")
    static let textFieldColor: Color = Color("textFieldColor")
    static let textColor: Color = Color("textColor")
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
