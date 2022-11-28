//
//  PlayerManager.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import AVFoundation

class PlayerManager {
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    private var trackCurrentIndex = -1
    
    static let shared = PlayerManager()
    private init() {}
    
    func play(currentTrack: TrackModel?) {
        guard let songURl = Bundle.main.url(forResource: currentTrack?.title, withExtension: nil) else { return }
        
        let playerItem = AVPlayerItem(url: songURl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func getDurationValue() -> Float {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return Float(percentage)
    }
    
    func rewindTrack(with percantage: Float) {
        if let durationTime = player.currentItem?.duration {
            let durationInSeconds = CMTimeGetSeconds(durationTime)
            let seekTimeInSeconds = Float64(percantage) * durationInSeconds
            let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1000)
            player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    
    func compareCurrentIndex(with index: Int, track: TrackModel?) {
        if trackCurrentIndex != index {
            play(currentTrack: track)
        }
        trackCurrentIndex = index
    }
}
