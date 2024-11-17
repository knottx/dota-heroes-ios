//
//  Data+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
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
