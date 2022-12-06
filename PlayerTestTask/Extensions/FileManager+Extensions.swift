//
//  FileManager+Extensions.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import Foundation

extension FileManager {
    func getDocumentDirectoryURL() -> URL? {
        return try? FileManager.default.url(
            for: .documentDirectory,
               in: .userDomainMask,
               appropriateFor: nil,
               create: true
        )
    }
}
