//
//  Data+Extension.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Foundation

extension Data {
    func jsonObject(options: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
        return try JSONSerialization.jsonObject(with: self, options: options) as? [String: Any]
    }

    func asString() -> String {
        return String(decoding: self, as: UTF8.self)
    }
}
