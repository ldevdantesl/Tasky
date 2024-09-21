//
//  DataStorageManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

protocol DataStorageManaging {
    func clearCache()
    var isArchiveAfterCompletionEnabled: Bool { get set }
    var archiveAfterDays: Int { get set }
    func archiveOldCompletedTodos()
    func resetDataAndStorageSettings()
}
