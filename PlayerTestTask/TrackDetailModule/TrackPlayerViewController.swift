//
//  TrackPlayerViewController.swift
//  PlayerTestTask
//
//  Created by Admin on 29.11.2022.
//

import Foundation
import UIKit
import CoreMedia

protocol TrackPlayerViewInput: UIViewController {
    func updatePlayButton(withImage image: UIImage)
    func updateTimeSlider(withProgress progress: Float)
    func setMinTimeLabel(withValue pastValue: Float,
                         andMaxTimeLabelWithValue remainValue: Float)
    func setNameLabel(withString string: String)
    func setAlbumImageView(_ image: UIImage)
    func setupNavigationBar()
    func setTimeOnSlider(pastTime: Float,
                         remainTime: Float)
    func setReplayCurrentButtonImage(_ image: UIImage)
}

protocol TrackPlayerViewOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
    func viewDidDisappearDone()
    func tracksCount() -> Int
    func previousButtonTapped()
    func nextButtonTapped()
    func playPauseButtonTapped()
    func sliderTimeBeganChange()
    func sliderTimeChanged(_ time: Float)
    func sliderTimeDragged(_ time: Float)
    func sliderVolumeChanged(_ time: Float)
    func maximumVolumeClicked()
    func muteVolumeClicked()
    func replayButtonChangeState()
}

class TrackPlayerViewController: UIViewController,
                                 TrackPlayerViewInput {
    
    var output: TrackPlayerViewOutput?
    static let storyboardIdentifier = "TrackPlayerControllerID"
    @IBOutlet weak private var volumeSlider: UISlider!
    @IBOutlet weak private var timeSlider: PlayerSlider!
    @IBOutlet weak private var songNameLabel: UILabel!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var albumImageView: UIImageView!
    @IBOutlet weak private var noteImage: UIImageView!
    @IBOutlet weak private var replayCurrentTrackButton: UIButton!
    
    // MARK: - IBActions
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        self.output?.previousButtonTapped()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        self.output?.playPauseButtonTapped()
    }
    
    @IBAction func replayCurrentTrackPressed(_ sender: UIButton) {
        self.output?.replayButtonChangeState()
    }
    
    func updatePlayButton(withImage image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.playButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.output?.nextButtonTapped()
    }
        
    @IBAction private func volumeSliderHandler(_ timeSlider: UISlider) {
        self.output?.sliderVolumeChanged(timeSlider.value)
    }
    
    @IBAction func muteButtonAction(_ sender: UIButton) {
        self.output?.muteVolumeClicked()
        volumeSlider.value = volumeSlider.minimumValue
    }
    
    @IBAction func maxLvlVolumeButtonAction(_ sender: UIButton) {
        self.output?.maximumVolumeClicked()
        volumeSlider.value = volumeSlider.maximumValue
    }
    
    // MARK: - deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeSlider.delegate = self
        self.output?.viewDidLoadDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.output?.viewDidDisappearDone()
    }
    
    func setTimeOnSlider(pastTime: Float,
                         remainTime: Float) {
        self.timeSlider.setTime(withPastTime: pastTime,
                                andRemainTime: remainTime)
    }
    
    func setAlbumImageView(_ image: UIImage) {
        DispatchQueue.main.async {
            self.albumImageView.image = image
        }
    }
    
    func setReplayCurrentButtonImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.replayCurrentTrackButton.setBackgroundImage(image,
                                                             for: .normal)
        }
    }
    
    func setupNavigationBar() {
        DispatchQueue.main.async {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = UIColor(named: "navBarColor")
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationItem.title = "Player"
        }
    }
    
    func setMinTimeLabel(withValue pastValue: Float,
                         andMaxTimeLabelWithValue remainValue: Float) {
        DispatchQueue.main.async {
            self.timeSlider.setTime(withPastTime: pastValue,
                                    andRemainTime: remainValue)
        }
    }
    
    func setNameLabel(withString string: String) {
        DispatchQueue.main.async {
            self.songNameLabel.text = string
        }
    }
    
    func updateTimeSlider(withProgress progress: Float) {
        self.timeSlider.updateProgress(withValue: progress)
    }
}

extension TrackPlayerViewController: PlayerSliderDelegate {
    
    func playerSliderValueBeganChange(_ playerSlider: PlayerSlider) {
        self.output?.sliderTimeBeganChange()
    }
    
    func playerSlider(_ playerSlider: PlayerSlider,
                      onSliderValueChanged progress: Float) {
        self.output?.sliderTimeDragged(progress)
    }
    
    func playerSlider(_ playerSlider: PlayerSlider,
                      rewindPlayerOnSliderValue progress: Float) {
        self.output?.sliderTimeChanged(progress)
    }
}
