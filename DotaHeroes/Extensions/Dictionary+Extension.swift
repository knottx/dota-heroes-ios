//
//  Dictionary+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Foundation

extension Dictionary {
    func data(option: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: option)
    }

    mutating func update(other: Dictionary) {
        for (_, dict) in other.enumerated() {
            self.updateValue(dict.value, forKey: dict.key)
        }
    }
}
