//
//  AppListPreferences.swift
//  sable
//
//  Created by Claude Code
//

import Foundation

struct AppListPreferences: Codable {
    var apps: [String]

    static let fileName = "appList.json"
    static let defaultApps = ["Chrome", "Safari", "Brave", "Firefox"]

    static func load() -> AppListPreferences {
        if Storage.fileExists(fileName, in: .documents) {
            return Storage.retrieve(fileName, from: .documents, as: AppListPreferences.self)
        }
        return AppListPreferences(apps: defaultApps)
    }

    func save() {
        Storage.store(self, to: .documents, as: AppListPreferences.fileName)
    }

    static func getAppList() -> [String] {
        return load().apps
    }
}
