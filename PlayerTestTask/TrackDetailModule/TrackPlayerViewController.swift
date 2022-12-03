//
//  TrackPlayerViewController.swift
//  PlayerTestTask
//
//  Created by Admin on 29.11.2022.
//

import Foundation
import UIKit

protocol TrackPlayerViewInput: AnyObject {
}

protocol TrackPlayerViewOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
    func tracksCount() -> Int
    var tracks: [TrackModel] { get }
}

class TrackPlayerViewController: UIViewController {
    var output: TrackPlayerViewOutput?
    static let storyboardIdentifier = "TrackPlayerControllerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavBarImage(withTitle: "LogoIcon")
        setSlidersThumbImage()
        run(track)
        updateUIOnPause()
        self.output?.viewDidLoadDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
    }
    
    
    // MARK: - IBActions
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        PlayerManager.shared.previousTrackClicked()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if audioPlayer.timeControlStatus == .playing {
            audioPlayer.pause()
            playButton.setImage(UIImage(named: "playBtn"), for: .normal)
        } else {
            audioPlayer.play()
            playButton.setImage(UIImage(named: "pauseBtn"), for: .normal)
        }
        
        PlayerManager.shared.playClicked()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        track = delegate?.playerViewControllerGetNextTrack(self)
        run(track)
    }
    
    @IBAction private func durationSliderHandler(_ sender: UISlider) {
        PlayerManager.shared.rewindTrack(with: durationSlider.value)
    }
    
    @IBAction private func volumeSliderHandler(_ sender: UISlider) {
        audioPlayer.isMuted = false
        audioPlayer.volume = volumeSlider.value
    }
    
    @IBAction func muteButtonAction(_ sender: UIButton) {
        audioPlayer.isMuted = true
        volumeSlider.value = volumeSlider.minimumValue
    }
    
    @IBAction func maxLvlVolumeButtonAction(_ sender: UIButton) {
        audioPlayer.isMuted = false
        audioPlayer.volume = 1
        volumeSlider.value = volumeSlider.maximumValue
    }
    
    // MARK: - deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    private func run(_ track: Track?) {
        PlayerManager.shared.compareCurrentIndex(
            with: delegate?.playerViewControllerGetIndexCell(self) ?? 0,
            track: track
        )
        updateLabels()
        observePlayerDurationTime()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: audioPlayer.currentItem
        )
    }
    
    @objc
    private func playerDidFinishPlaying(note: NSNotification) {
        track = delegate?.playerViewControllerGetNextTrack(self)
        run(track)
    }
    
    private func updateLabels() {
        songNameLabel.text = track?.title
    }
    
    private func observePlayerDurationTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        audioPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            self.minTimeLabel.text = time.displayStringValue()
            
            if let durationTime = self.audioPlayer.currentItem?.duration {
                let currentDurationText = (durationTime - time).displayStringValue()
                self.maxTimeLabel.text = "\(currentDurationText)"
                self.updateDurationSlider()
            }
        }
    }
    
    private func updateDurationSlider() {
        durationSlider.value = PlayerManager.shared.getDurationValue()
    }
    
    private func setSlidersThumbImage() {
        durationSlider.setThumbImage(UIImage(named: "sliderKnob"), for: .normal)
        volumeSlider.setThumbImage(UIImage(named: "sliderKnob"), for: .normal)
    }
    
    private func updateUIOnPause() {
        if audioPlayer.timeControlStatus == .paused {
            playButton.setImage(UIImage(named: "playBtn"), for: .normal)
            minTimeLabel.text = audioPlayer.currentTime().displayStringValue()
            let diff = (audioPlayer.currentItem?.duration.seconds ?? 0) - audioPlayer.currentTime().seconds
            maxTimeLabel.text = diff.asString(style: .positional)
            updateDurationSlider()
        }
    }
}
