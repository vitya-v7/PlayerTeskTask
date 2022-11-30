//
//  PlayerManager.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import AVFoundation

protocol PlayerManagerDelegate {
    func getTrack(withIndex index: Int) -> TrackModel?
    
}

class PlayerManager: PlayerManagerDelegate {
    
    static let shared = PlayerManager()
    private init() {}
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    private var trackCurrentIndex = -1
    
    lazy var defaultTracks: [TrackModel] = {
        var tracks = [TrackModel]()
        
        let urls = DataManager.shared.getUrls()
        let fileNames = DataManager.shared.getFileNames()
        let durations = DataManager.shared.getSongDurations()
        
        for index in 0...(fileNames.count - 1) {
            let fileName = fileNames.indices.contains(index) ? fileNames[index] : ""
            let duration = durations.indices.contains(index) ? durations[index] : "00:00"
            var trackURL: URL? = urls.indices.contains(index) ? urls[index] : nil
            if urls.indices.contains(index) {
                trackURL = urls[index]
            }
            tracks.append(TrackModel(title: fileNames[index],
                                     duration: durations[index],
                                     trackURL: urls[index]))
            
        }
        return tracks
    }()
    
    func play(trackWithIndex trackIndex: Int) {
        guard self.defaultTracks.indices.contains(trackIndex),
              let trackURl = self.defaultTracks[trackIndex].trackURL else { return }
        self.trackCurrentIndex = trackIndex
        let playerItem = AVPlayerItem(url: trackURl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func playNextTrack() {
        self.trackCurrentIndex = (self.trackCurrentIndex + 1) % self.defaultTracks.count
        self.play(trackWithIndex: self.trackCurrentIndex)
    }
    
    func playPreviousTrack() {
        if self.trackCurrentIndex - 1 < 0 {
            self.trackCurrentIndex = self.defaultTracks.count - 1
        } else {
            self.trackCurrentIndex = (self.trackCurrentIndex - 1) % self.defaultTracks.count
        }
        self.play(trackWithIndex: self.trackCurrentIndex)
    }
    
    func getDurationValue() -> Float {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return Float(percentage)
    }
    
    func rewindTrack(with percentage: Float) {
        guard let durationTime = player.currentItem?.duration else {
            return
        }
        let durationInSeconds = CMTimeGetSeconds(durationTime)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1000)
        player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    
    func getTrack(withIndex index: Int) -> TrackModel? {
        guard self.defaultTracks.indices.contains(index) else {
            return nil
        }
        return self.defaultTracks[index]
    }
}
