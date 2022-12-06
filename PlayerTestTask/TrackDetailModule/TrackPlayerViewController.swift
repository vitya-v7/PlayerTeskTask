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
    func setSlidersThumb(withImage image: UIImage)
    func updateTimeSlider(withValue value: Float)
    func setMinTimeLabel(withString string: String)
    func setMaxTimeLabel(withString string: String)
    func setNameLabel(withString string: String)
}

protocol TrackPlayerViewOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
    func tracksCount() -> Int
    func previousButtonTapped()
    func nextButtonTapped()
    func playButtonTapped()
    func sliderTimeChanged(_ time: Float)
    func sliderVolumeChanged(_ time: Float)
    func maximumVolumeClicked()
    func muteVolumeClicked()
}

class TrackPlayerViewController: UIViewController,
                                 TrackPlayerViewInput {
    var output: TrackPlayerViewOutput?
    static let storyboardIdentifier = "TrackPlayerControllerID"
    @IBOutlet weak private var volumeSlider: UISlider!
    @IBOutlet weak private var timeSlider: UISlider!
    @IBOutlet weak private var songNameLabel: UILabel!
    @IBOutlet weak private var playButton: UIButton!
    @IBOutlet weak private var minTimeLabel: UILabel!
    @IBOutlet weak private var maxTimeLabel: UILabel!
    @IBOutlet weak private var albumImageView: UIImageView!
    
    // MARK: - IBActions
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        self.output?.previousButtonTapped()
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        self.output?.playButtonTapped()
    }
    
    func updatePlayButton(withImage image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.playButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.output?.nextButtonTapped()
    }
    
    @IBAction private func durationSliderHandler(_ timeSlider: UISlider) {
        self.output?.sliderTimeChanged(timeSlider.value)
    }
    
    @IBAction private func volumeSliderHandler(_ timeSlider: UISlider) {
        self.output?.sliderVolumeChanged(timeSlider.value)
    }
    
    @IBAction func muteButtonAction(_ sender: UIButton) {
        self.output?.muteVolumeClicked()
    }
    
    @IBAction func maxLvlVolumeButtonAction(_ sender: UIButton) {
        self.output?.maximumVolumeClicked()
        volumeSlider.value = volumeSlider.maximumValue
    }
    
    // MARK: - deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output?.viewDidLoadDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
    }
    
    func setMinTimeLabel(withString string: String) {
        DispatchQueue.main.async {
            self.minTimeLabel.text = string
        }
    }
    
    func setMaxTimeLabel(withString string: String) {
        DispatchQueue.main.async {
            self.maxTimeLabel.text = string
        }
    }
    
    func setNameLabel(withString string: String) {
        DispatchQueue.main.async {
            self.songNameLabel.text = string
        }
    }
    
    func updateTimeSlider(withValue value: Float) {
        DispatchQueue.main.async {
            self.timeSlider.value = value
        }
    }
    
    func setSlidersThumb(withImage image: UIImage) {
        DispatchQueue.main.async {            self.timeSlider.setThumbImage(image, for: .normal)
            self.volumeSlider.setThumbImage(image, for: .normal)
        }
    }
    
}
