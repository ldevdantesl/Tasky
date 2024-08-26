//
//  ColorThemes.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 26.08.2024.
//

import Foundation
import SwiftUI

enum ColorThemes: String, CaseIterable {
    case blue
    case yellow
    case orange
    case green
    case purple
    case mint
    case teal
    
    var color: Color {
        switch self {
        case .blue:
            return Color.blue
        case .yellow:
            return Color.yellow
        case .orange:
            return Color.orange
        case .green:
            return Color.green
        case .purple:
            return Color.purple
        case .mint:
            return Color.mint
        case .teal:
            return Color.teal
        }
    }
}
