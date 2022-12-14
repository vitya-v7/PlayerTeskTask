//
//  ExportSessionHelper.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import AVFoundation

class ExportSessionHelper {
    
    private var exportSession: AVAssetExportSession?
    
    func exportAudioItem(_ item: TrackModel,
                         withExportSession exportSession: AVAssetExportSession,
                         andCompletion completion: @escaping ((TrackModel) -> Void),
                         errorCompletion: @escaping ((String?) -> Void)) {
        guard let tempFileUrl = DataManager.shared.getTempURLToItem(item,
                                                                    withExtension: "m4a") else {
            return
        }
        do {
            if FileManager.default.fileExists(atPath: tempFileUrl.path) {
                try FileManager.default.removeItem(at: tempFileUrl)
            }
        } catch {
            errorCompletion(error.localizedDescription)
            return
        }
        
        exportSession.outputURL = tempFileUrl
        exportSession.outputFileType = .m4a
        var mutableItem = item
        
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .failed:
                errorCompletion(exportSession.error?.localizedDescription)
            case .cancelled:
                errorCompletion("Export canceled")
            case .completed:
                print("Export is successful!")
                mutableItem.trackURL = tempFileUrl
                completion(mutableItem)
            default: break
            }
        })
    }
    
    func exportAudioItem(_ item: TrackModel,
                         andCompletion completion: @escaping ((TrackModel) -> Void),
                         errorCompletion: @escaping ((String?) -> Void)) {
        let assetItem = AVAsset(url: item.trackURL)
        guard let exportSession = AVAssetExportSession(asset: assetItem, presetName: AVAssetExportPresetAppleM4A) else {
            return
        }
        self.exportAudioItem(item,
                             withExportSession: exportSession,
                             andCompletion: completion,
                             errorCompletion: errorCompletion)
        
    }
    
    func exportVideoItem(_ item: TrackModel,
                         withCompletion completion: @escaping ((TrackModel) -> Void),
                         errorCompletion: @escaping ((String?) -> Void)) {
        item.trackURL.startAccessingSecurityScopedResource()
        let assetItem = AVAsset(url: item.trackURL)
        let newAudioAsset = AVMutableComposition()
        let dstCompositionTrack = newAudioAsset.addMutableTrack(withMediaType: .audio,
                                                                preferredTrackID: kCMPersistentTrackID_Invalid)
        let scrAsset = assetItem
        let tracks = scrAsset.tracks(withMediaType: .audio)
        guard !tracks.isEmpty && scrAsset.duration.seconds > 0 else {
            errorCompletion("No audio track")
            return
        }
        let clipAudioTrack = tracks.first
        guard let clipAudioTrack = clipAudioTrack else {
            errorCompletion(nil)
            return
        }
        let timeRange = CMTimeRange(start: CMTime(seconds: 0,
                                                  preferredTimescale: CMTimeScale(60000)),
                                    duration: CMTime(seconds: scrAsset.duration.seconds,
                                                     preferredTimescale: CMTimeScale(60000)))
        do {
            try dstCompositionTrack?.insertTimeRange(timeRange,
                                             of: clipAudioTrack,
                                             at: .zero)
        } catch {
            errorCompletion(error.localizedDescription)
            return
        }
        guard let exportSession = AVAssetExportSession(asset: newAudioAsset,
                                                       presetName: AVAssetExportPresetAppleM4A) else {
            errorCompletion("Export session failed")
            return
        }
        self.exportSession = exportSession
        self.exportAudioItem(item,
                             withExportSession: exportSession, andCompletion: { item in
            completion(item)
        }, errorCompletion: errorCompletion)
                
    }
}
