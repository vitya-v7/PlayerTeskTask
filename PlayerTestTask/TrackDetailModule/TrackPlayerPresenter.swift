//
//  TrackPlayerPresenter.swift
//  PlayerTestTask
//
//  Created by Admin on 29.11.2022.
//

import Foundation
import UIKit
import CoreMedia

class TrackPlayerPresenter: TrackPlayerViewOutput {
    
    var playerManager: PlayerManagerProtocol
    weak var view: TrackPlayerViewInput?
    
    init(withPlayerManager playerManager: PlayerManager,
         andIndex index: Int) {
        self.playerManager = playerManager
        self.playerManager.replaceTrack(withTrackWithIndex: index)
        self.playerManager.playClicked()
    }
    
    @objc
    private func playerDidFinishPlaying(note: NSNotification) {
        self.playerManager.nextTrackClicked()
    }
    
    func observePlayerDurationTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
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
        self.view?.addNavBarImage(withTitle: "LogoIcon")
        self.observePlayerDurationTime()
        self.updateTrackAppearance()
        self.playerManager.playClicked()
    }
    
    func viewDidAppearDone() {
        self.updateTrackAppearance()
    }
    
    func updateTrackAppearance() {
        guard let track = self.playerManager.getCurrentTrack() else {
            return
        }
        
        self.view?.setNameLabel(withString: track.title)
        if let thumbImage = UIImage(named: "sliderKnob") {
            self.view?.setSlidersThumb(withImage: thumbImage)
        }
        self.updateDurationTrackAppearance(withCurrentTime: self.playerManager.getCurrentTime())
        self.updatePlayButtonImage()
       
    }
    
    func updateDurationTrackAppearance(withCurrentTime currentTime: CMTime) {
        self.view?.setMinTimeLabel(withString: "\(currentTime.displayStringValue())")
        
        let durationTime = self.playerManager.getDuration()
        let currentDurationText = (durationTime - currentTime).displayStringValue()
        self.view?.setMaxTimeLabel(withString: "\(currentDurationText)")
        self.view?.updateTimeSlider(withValue: self.playerManager.getNormalizedCurrentTime())
    }
    
    func sliderTimeChanged(_ time: Float) {
        playerManager.rewind(withPercentageClicked: time)
    }
    
    func tracksCount() -> Int {
        return self.playerManager.getTracksCount()
    }
    
    func previousButtonTapped() {
        self.playerManager.previousTrackClicked()
        self.view?.updateTimeSlider(withValue: 0)
    }
    
    func nextButtonTapped() {
        self.playerManager.nextTrackClicked()
        self.view?.updateTimeSlider(withValue: 0)
    }
    
    func playButtonTapped() {
        self.playerManager.playClicked()
        self.updatePlayButtonImage()
    }
    
    func updatePlayButtonImage() {
        var image: UIImage?
        if self.playerManager.getCurrentState() == .play {
            image = UIImage(named: "playBtn")
        } else {
            image = UIImage(named: "pauseBtn")
        }
        if let image = image {
            self.view?.updatePlayButton(withImage: image)
        }
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

