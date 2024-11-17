//
//  AppLogger.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Foundation

enum AppLogger: String {
    case request
    case response
    case log

    var name: String {
        return self.rawValue.capitalized
    }

    var symbol: String {
        switch self {
        case .request: return "📡"
        case .response: return "✏️"
        case .log: return "📝"
        }
    }

    func message(_ value: String) -> String {
        let time = Date().toString(format: "HH:mm:ss")
        return "\(self.symbol): (\(time)) [\(self.name)] => \(value)"
    }

    func log(_ value: String) {
        #if DEBUG
        print(self.message(value))
        #endif
    }
}
