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
    private var libraryTrackAssets: [AVURLAsset]
    private init() {
        
        guard
            let bundleURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: "Mp3 tracks")
        else { fatalError("Failed to get urls") }
        self.libraryTrackAssets = []
        for url in bundleURLs {
            let asset = AVURLAsset(url: url)
            self.libraryTrackAssets.append(asset)
        }
        guard let savedURLs = FileManager.default.getDocumentDirectoryURL() else {
            return
        }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: savedURLs, includingPropertiesForKeys: nil)
            for url in fileURLs {
                let asset = AVURLAsset(url: url)
                self.libraryTrackAssets.append(asset)
            }
            
        } catch {
            print("No added files")
        }
    }
    
    func getTracks(byUrl urls: [URL]? = nil) -> [TrackModel] {
        var assets = self.libraryTrackAssets
        if let urls = urls, !urls.isEmpty {
            assets = []
            for url in urls {
                assets.append(AVURLAsset(url: url))
            }
        }
        
        var trackModels = [TrackModel]()
        
        for asset in assets {
            let items = AVMetadataItem.metadataItems(from: asset.metadata,
                                                     withKey: AVMetadataKey.commonKeyArtwork,
                                                     keySpace: .common)
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
                    if let imageData = item.value as? Data,
                       let artworkImage = UIImage(data: imageData) {
                        artwork = artworkImage
                    }
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
    
    func getTempURLToItem(_ item: TrackModel,
                          withExtension fileExtension: String) -> URL? {
        
        guard let baseTempUrl = FileManager.default.getDocumentDirectoryURL() else {
            return nil
        }
        
        let tempFileUrl = baseTempUrl.appendingPathComponent(item.trackURL.getFileName())
            .appendingPathExtension(fileExtension)
        
        return tempFileUrl
    }
}
