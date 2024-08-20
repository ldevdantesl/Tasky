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
