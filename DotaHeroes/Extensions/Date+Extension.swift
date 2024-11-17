//
//  Date+Extension.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
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
