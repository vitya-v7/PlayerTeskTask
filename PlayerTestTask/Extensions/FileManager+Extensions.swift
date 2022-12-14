//
//  FileManager+Extensions.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import AVFoundation
import UIKit

extension FileManager {
    func getDocumentDirectoryURL() -> URL? {
        let url = try? FileManager.default.url(
            for: .documentDirectory,
               in: .userDomainMask,
               appropriateFor: nil,
               create: true
        )
        guard let folderURL = url?.appendingPathComponent("MusicFilesStorage", isDirectory: true) else {
            return nil
        }
        if !FileManager.default.fileExists(atPath: folderURL.path,
                                           isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: folderURL,
                                                withIntermediateDirectories: false,
                                                attributes: nil)
            } catch {
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    
                    AlertHelper().showSimpleAlert(inViewController: topController,
                                                  withTitle: "Error",
                                                  message: error.localizedDescription,
                                                  confirmBlock: nil)
                }
            }
        }
        return folderURL
    }
}
