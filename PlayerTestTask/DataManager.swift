//
//  FileManager.swift
//  MusicPlayer
//
//  Created by oleg.fedorov on 24.05.2022.
//

import Foundation
import AVFoundation

class DataManager {
        
    static let shared = DataManager()
    private let trackAssets: [AVURLAsset]
    private init() {
        
        let bundleURLs = getUrls()
        self.trackAssets = []
        for url in bundleURLs {
            let asset = AVURLAsset(url: url)
            self.trackAssets.append(asset)
        }
    }
    
    func getUrls() -> [URL] {
        guard
            let bundleURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        else { fatalError("Failed to get urls") }
        
        return bundleURLs
    }
    
    func getFileNames() -> [String] {
        var fileNames = [String]()
        
        for asset in trackAssets {
            let items = AVMetadataItem.metadataItems(from: asset.metadata, with: .current)
            
            if !items.isEmpty {
                for item in items where item.commonKey == .commonKeyTitle {
                    fileNames.append(item.stringValue ?? "")
                }
            } else {
                fileNames.append(asset.url.lastPathComponent)
            }
        }
        
        return fileNames
    }
    
    func getSongDurations() -> [String] {
        var durations = [String]()
        
        for asset in trackAssets {
            let audioDuration = asset.duration
            durations.append(audioDuration.displayStringValue())
        }
        
        return durations
    }
}
