//
//  FileManager.swift
//  MusicPlayer
//
//  Created by oleg.fedorov on 24.05.2022.
//

import Foundation
import AVFoundation
import UIKit

class DataManager {
        
    static let shared = DataManager()
    private var trackAssets: [AVURLAsset]
    private init() {
        
        guard
            let bundleURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: "Mp3 tracks")
        else { fatalError("Failed to get urls") }
        self.trackAssets = []
        for url in bundleURLs {
            let asset = AVURLAsset(url: url)
            self.trackAssets.append(asset)
        }
    }
    
    func getTracks() -> [TrackModel] {
        var trackModels = [TrackModel]()
        
        for asset in self.trackAssets {
            let items = AVMetadataItem.metadataItems(from: asset.metadata, with: .current)
            var title = asset.url.deletingPathExtension().lastPathComponent
            let audioDuration = asset.duration.displayStringValue()
            var artwork = UIImage(named: "cover")
            for item in items {
                guard let commonKey = item.commonKey else {
                    continue
                }
                var artistName: String?
                var trackName: String?
                
                switch commonKey {
                case .commonKeyArtist:
                    artistName = item.stringValue
                case .commonKeyTitle:
                    trackName = item.stringValue
                case .commonKeyArtwork:
                    artwork = UIImage(named: item.stringValue ?? "cover")
                default:
                    break
                }
                if let artistName = artistName,
                   let trackName = trackName {
                    title = artistName + " - " + trackName
                }
            }
            
            trackModels.append(TrackModel(title: title,
                                          duration: audioDuration,
                                          artworkImage: artwork,
                                          trackURL: asset.url))
        }
        return trackModels
    }
}
