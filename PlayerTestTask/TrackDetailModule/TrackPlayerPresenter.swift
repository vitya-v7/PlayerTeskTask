//
//  TrackPlayerPresenter.swift
//  PlayerTestTask
//
//  Created by Admin on 29.11.2022.
//

import Foundation
import UIKit
import CoreMedia

class TrackPlayerPresenter: TrackPlayerViewOutput,
                            PlayerManagerDelegate {
 
    var playerManager: PlayerManagerProtocol
    weak var view: TrackPlayerViewInput?
    
    init(withPlayerManager playerManager: PlayerManager,
         andIndex index: Int) {
        self.playerManager = playerManager
        self.playerManager.setCurrentTrackIndex(index)
        self.playerManager.setDelegate(self)
    }
    
    @objc
    private func playerDidFinishPlaying(note: NSNotification) {
        self.nextButtonTapped()
    }
    
    func observePlayerDurationTime() {
        let interval = CMTimeMake(value: 1, timescale: 60000)
        
        self.playerManager.addPeriodicObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.updateDurationTrackAppearance(withCurrentTime: time)
        }
    }
        
    func viewDidLoadDone() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        self.view?.setupNavigationBar()
        self.observePlayerDurationTime()
        self.updateTrackAppearance()
        
        self.playerManager.replaceTrack {
            self.playerManager.playClicked()
        }
    }
    
    func viewDidAppearDone() {
        self.updateTrackAppearance()
    }
    
    func viewDidDisappearDone() {}
    
    func updateTrackAppearance() {
        guard let track = self.playerManager.getCurrentTrack() else {
            return
        }
        
        self.view?.setNameLabel(withString: track.title)
        self.updateDurationTrackAppearance(withCurrentTime: self.playerManager.getCurrentTime())
        self.updatePlayButtonImage()
        if let artworkImage = track.artworkImage {
            self.view?.setAlbumImageView(artworkImage)
        }
    }
    
    func updateDurationTrackAppearance(withCurrentTime currentTime: CMTime) {
        
        let durationTime = self.playerManager.getDuration()
        let pastTime = Float(currentTime.seconds)
        let remainTime = Float((durationTime - currentTime).seconds)
        self.view?.updateTimeSlider(withProgress: pastTime / Float(durationTime.seconds))
        self.view?.setMinTimeLabel(withValue: pastTime,
                                   andMaxTimeLabelWithValue: remainTime)
    }
    
    func sliderTimeBeganChange() {
        self.playerManager.removePeriodicTimeObserver()
    }
    
    func sliderTimeChanged(_ time: Float) {
        playerManager.rewind(withPercentageClicked: time)
        self.observePlayerDurationTime()
    }
    
    func sliderTimeDragged(_ time: Float) {
        let duration = Float(self.playerManager.getDuration().seconds)
        let currentTime = self.playerManager.time(byPercentage: time)
        self.view?.setTimeOnSlider(pastTime: currentTime,
                                   remainTime: duration - currentTime)
    }
    
    func tracksCount() -> Int {
        return self.playerManager.getTracksCount()
    }
    
    func previousButtonTapped() {
        self.playerManager.previousTrackClicked()
        self.updateTrackAppearance()
        self.updateDurationTrackAppearance(
            withCurrentTime: CMTime(seconds: 0, preferredTimescale: 60000))
    }
    
    func nextButtonTapped() {
        self.playerManager.nextTrackClicked()
        self.updateTrackAppearance()
        self.updateDurationTrackAppearance(
            withCurrentTime: CMTime(seconds: 0, preferredTimescale: 60000))
    }
    
    func playButtonTapped() {
        self.playerManager.playClicked()
        self.updatePlayButtonImage()
    }
    
    func updatePlayButtonImage() {
        guard let image = self.playerManager.getButtonImage() else {
            return
        }
        self.view?.updatePlayButton(withImage: image)
    }
    
    func sliderValueChanged(_ percentage: Float) {
        self.playerManager.rewind(withPercentageClicked: percentage)
    }
    
    func sliderVolumeChanged(_ volume: Float) {
        self.playerManager.changeVolume(volume)
    }
    
    func maximumVolumeClicked() {
        self.playerManager.changeVolume(1.0)
    }
    
    func muteVolumeClicked() {
        self.playerManager.changeVolume(0.0)
    }
    
}
