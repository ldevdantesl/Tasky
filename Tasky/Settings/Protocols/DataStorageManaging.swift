//
//  DataStorageManaging.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 23.08.2024.
//

import Foundation

protocol DataStorageManaging {
    func fetchArchivedTodos() -> [Todo]
    func fetchDeletedTodos() -> [Todo]
    func clearCache()
    func archiveTodos()
    func deleteTodos()
    var isArchiveAfterCompletionEnabled: Bool { get set }
    var archiveAfterDays: Int { get set }
    func resetDataAndStorageSettings()
}
