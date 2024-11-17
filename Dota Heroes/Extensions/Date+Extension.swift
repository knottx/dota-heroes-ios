//
//  Date+Extension.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import UIKit

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
