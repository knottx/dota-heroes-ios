//
//  Dictionary+Extension.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
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
