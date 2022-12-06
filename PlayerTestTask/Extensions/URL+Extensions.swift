//
//  URL+Extensions.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import Foundation

extension URL {
    func getFileName() -> String {
        return self.deletingPathExtension().lastPathComponent
    }
}
