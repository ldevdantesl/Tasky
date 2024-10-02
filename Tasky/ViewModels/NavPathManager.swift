//
//  NavPathManager.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 2.10.2024.
//

import Foundation
import SwiftUI

class NavPathManager: ObservableObject{
    @Published var path: NavigationPath = NavigationPath()
}
