//
//  PlayerManager.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import AVFoundation
import UIKit

protocol PlayerManagerProtocol {
    func getTrack(withIndex index: Int) -> TrackModel?
    func getTracksCount() -> Int
    func getCurrentTrack() -> TrackModel?
    func playClicked()
    func rewind(withPercentageClicked percentage: Float)
    func nextTrackClicked()
    func previousTrackClicked()
    func addPeriodicObserver(forInterval interval: CMTime,
                             queue: DispatchQueue,
                             observer: @escaping ((CMTime) -> Void))
    func removePeriodicTimeObserver()
    func getCurrentTime() -> CMTime
    func getDuration() -> CMTime
    func changeVolume(_ volume: Float)
    func getCurrentTrackIndex() -> Int
    func replaceTrack(withTrackWithIndex trackIndex: Int,
                      andCompletion completion: (() -> Void)?)
    func getButtonImage() -> UIImage?
    func time(byPercentage percentage: Float) -> Float
    func setDelegate(_ delegate: PlayerManagerDelegate)
    func setCurrentTrackIndex(_ index: Int)
}

extension PlayerManagerProtocol {
    func replaceTrack(withCompletion completion: (() -> Void)?) {
        self.replaceTrack(withTrackWithIndex: self.getCurrentTrackIndex(),
                          andCompletion: completion)
    }
}

protocol PlayerManagerDelegate: AnyObject {
    func updateTrackAppearance()
}

enum PlayerManagerState {
    case play, pause, stop, none
}

class PlayerManager: PlayerManagerProtocol {
    
    private weak var delegate: PlayerManagerDelegate?
    private var currentState: PlayerStateProtocol
    var trackCurrentIndex = -1
    private var periodicTimeObserver: Any?
    
    init() {
        self.currentState = StopState.shared
    }
    
    func setDelegate(_ delegate: PlayerManagerDelegate) {
        self.delegate = delegate
    }
    
    func getCurrentTrack() -> TrackModel? {
        guard self.defaultTracks.indices.contains(self.trackCurrentIndex) else {
            return nil
        }
        return self.defaultTracks[self.trackCurrentIndex]
    }
    
    func isPlaying() -> Bool {
        return self.currentState is PlayState
    }
    
    func getCurrentTrackIndex() -> Int {
        return self.trackCurrentIndex
    }
    
    func getCurrentTime() -> CMTime {
        return self.player.currentItem?.currentTime() ?? .zero
    }
    
    func getDuration() -> CMTime {
        let duration = self.player.currentItem?.duration ??
        CMTimeMake(value: 1, timescale: 60000)
        return duration
    }
    
    func getButtonImage() -> UIImage? {
        self.currentState.managerButtonImage(self)
    }
    
    func getTracksCount() -> Int {
        return self.defaultTracks.count
    }
    
    func addTracks(withModels trackModels: [TrackModel]) {
        self.defaultTracks.append(contentsOf: trackModels)
    }
    
    func playClicked() {
        self.currentState.managerPlay(self)
    }
    
    func rewind(withPercentageClicked percentage: Float) {
        self.currentState.manager(self,
                                  rewindTrackWithPercentage: percentage)
    }
    
    func previousTrackClicked() {
        self.currentState.managerPreviousTrackSelected(self)
    }
    
    func nextTrackClicked() {
        self.currentState.managerNextTrackSelected(self)
    }
    
    func addPeriodicObserver(forInterval interval: CMTime,
                             queue: DispatchQueue,
                             observer: @escaping ((CMTime) -> Void)) {
        let interval = CMTimeMake(value: 1, timescale: 60000)
        self.periodicTimeObserver = self.player.addPeriodicTimeObserver(forInterval: interval,
                                            queue: queue) { time in
            observer(time)
        }
    }
    
    func removePeriodicTimeObserver() {
        if let periodicTimeObserver = periodicTimeObserver {
            self.player.removeTimeObserver(periodicTimeObserver)
        }
    }
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    private lazy var defaultTracks: [TrackModel] = {
        DataManager.shared.getTracks()
    }()
    
    func changeVolume(_ volume: Float) {
        self.player.volume = volume
    }
    
    func getTrack(withIndex index: Int) -> TrackModel? {
        guard self.defaultTracks.indices.contains(index) else {
            return nil
        }
        return self.defaultTracks[index]
    }
}

extension PlayerManager: PlayerManagerContext {
    func setState(_ playerState: PlayerStateProtocol) {
        self.currentState = playerState
    }
    
    func play(trackWithIndex trackIndex: Int) {
        self.replaceTrack(withTrackWithIndex: trackIndex) {
            self.play()
        }
    }
    
    func setCurrentTrackIndex(_ index: Int) {
        self.trackCurrentIndex = index
    }
    
    func replaceTrack(withTrackWithIndex trackIndex: Int,
                      andCompletion completion: (() -> Void)? = nil) {
        guard self.defaultTracks.indices.contains(trackIndex) else { return }
        let trackURl = self.defaultTracks[trackIndex].trackURL
        self.trackCurrentIndex = trackIndex
        let assetKeys = ["playable", "duration", "currentTime"]

        let asset = AVAsset(url: trackURl)
        asset.loadValuesAsynchronously(forKeys: assetKeys, completionHandler: {
            let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
            
            self.player.replaceCurrentItem(with: playerItem)
            self.delegate?.updateTrackAppearance()
            completion?()
        })
    }
    
    func changeOnNextTrack() {
        self.trackCurrentIndex = (self.trackCurrentIndex + 1) % self.defaultTracks.count
        self.replaceTrack(withTrackWithIndex: self.trackCurrentIndex)
    }
    
    func changeOnPreviousTrack() {
        if self.trackCurrentIndex - 1 < 0 {
            self.trackCurrentIndex = self.defaultTracks.count - 1
        } else {
            self.trackCurrentIndex = (self.trackCurrentIndex - 1) % self.defaultTracks.count
        }
        self.replaceTrack(withTrackWithIndex: self.trackCurrentIndex)
    }
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
    func stop() {
        self.player.pause()
        self.rewindTrack(with: 0)
        self.player.pause()
    }
    
    func rewindTrack(with percentage: Float) {
        let seekTime = CMTimeMakeWithSeconds(
            Float64(self.time(byPercentage: percentage)),
                                             preferredTimescale: 60000)
        self.player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    
    func time(byPercentage percentage: Float) -> Float {
        guard let durationTime = player.currentItem?.duration else {
            return 0.0
        }
        let durationInSeconds = CMTimeGetSeconds(durationTime)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        return Float(seekTimeInSeconds)
    }
}
