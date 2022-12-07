//
//  PlayerManager.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import AVFoundation

protocol PlayerManagerProtocol {
    func getTrack(withIndex index: Int) -> TrackModel?
    func getTracksCount() -> Int
    func getCurrentTrack() -> TrackModel?
    func getCurrentState() -> PlayerManagerState
    func playClicked()
    func pauseClicked()
    func stopClicked()
    func rewind(withPercentageClicked percentage: Float)
    func nextTrackClicked()
    func previousTrackClicked()
    func getNormalizedCurrentTime() -> Float
    func addPeriodicObserver(forInterval interval: CMTime,
                             queue: DispatchQueue,
                             observer: @escaping ((CMTime) -> ()))
    func getCurrentTime() -> CMTime
    func getDuration() -> CMTime
    func changeVolume(_ volume: Float)
    func getCurrentTrackIndex() -> Int
    
    func replaceTrack(withTrackWithIndex trackIndex: Int)
}

enum PlayerManagerState {
    case play, pause, stop, none
}

class PlayerManager: PlayerManagerProtocol {
    
    private var currentState: PlayerStateProtocol
    var trackCurrentIndex = -1
    
    init() {
        self.currentState = StopState.shared
    }
    
    func getCurrentState() -> PlayerManagerState {
        switch self.currentState {
        case is PlayState:
            return .play
        case is PauseState:
            return .pause
        case is StopState:
            return .stop
        default:
            return .none
        }
    }
    
    func getCurrentTrack() -> TrackModel? {
        guard self.defaultTracks.indices.contains(self.trackCurrentIndex) else {
            return nil
        }
        return self.defaultTracks[self.trackCurrentIndex]
    }
    
    func getCurrentTrackIndex() -> Int {
        return self.trackCurrentIndex
    }
    
    func getCurrentTime() -> CMTime {
        return self.player.currentTime()
    }
    
    func getNormalizedCurrentTime() -> Float {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        return Float(percentage)
    }
    
    func getDuration() -> CMTime {
        let duration = self.player.currentItem?.duration ??
        CMTimeMake(value: 1, timescale: 1)
        return duration
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
    
    func pauseClicked() {
        self.currentState.managerPause(self)
    }
    
    func stopClicked() {
        self.currentState.managerStop(self)
    }
    
    func rewind(withPercentageClicked percentage: Float) {
        self.currentState.manager(self,
                                  rewindTrackWithPercentage: percentage)
    }
    
    func nextTrackClicked() {
        self.currentState.managerNextTrackSelected(self)
    }
    
    func addPeriodicObserver(forInterval interval: CMTime,
                             queue: DispatchQueue,
                             observer: @escaping ((CMTime) -> ())) {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        self.player.addPeriodicTimeObserver(forInterval: interval,
                                            queue: queue) { time in
            observer(time)
        }
    }
    
    func previousTrackClicked() {
        self.currentState.managerPreviousTrackSelected(self)
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
        self.replaceTrack(withTrackWithIndex: trackIndex)
        self.player.play()
    }
    
    func replaceTrack(withTrackWithIndex trackIndex: Int) {
        guard self.defaultTracks.indices.contains(trackIndex) else { return }
        let trackURl = self.defaultTracks[trackIndex].trackURL
        self.trackCurrentIndex = trackIndex
        let playerItem = AVPlayerItem(url: trackURl)
        self.player.replaceCurrentItem(with: playerItem)
    }
    
    func changeOnNextTrack() {
        self.trackCurrentIndex = (self.trackCurrentIndex + 1) % self.defaultTracks.count
    }
    
    func changeOnPreviousTrack() {
        if self.trackCurrentIndex - 1 < 0 {
            self.trackCurrentIndex = self.defaultTracks.count - 1
        } else {
            self.trackCurrentIndex = (self.trackCurrentIndex - 1) % self.defaultTracks.count
        }
    }
    
    func play() {
        self.play(trackWithIndex: self.trackCurrentIndex)
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
        guard let durationTime = player.currentItem?.duration else {
            return
        }
        let durationInSeconds = CMTimeGetSeconds(durationTime)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1000)
        player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}
