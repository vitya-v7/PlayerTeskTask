//
//  Double+Extensions.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import Foundation

extension Double {
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = style
        return formatter.string(from: self) ?? ""
    }
}
