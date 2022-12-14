//
//  PlayerSlider.swift
//  PlayerTestTask
//
//  Created by Admin on 08.12.2022.
//

import AVFoundation
import UIKit

protocol PlayerSliderDelegate: class {
    func playerSliderValueBeganChange(_ playerSlider: PlayerSlider)
    func playerSlider(_ playerSlider: PlayerSlider,
                      onSliderValueChanged progress: Float)
    func playerSlider(_ playerSlider: PlayerSlider,
                      rewindPlayerOnSliderValue progress: Float)
}

class PlayerSlider: ViewWithXib {
    
    private let maximumUnitCount = 2
    weak var delegate: PlayerSliderDelegate?
    
    private var isDragging = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sliderView.delegate = self
    }
	@IBOutlet private weak var pastLabel: UILabel!
	@IBOutlet private weak var remainLabel: UILabel!
    @IBOutlet private weak var sliderView: CustomSliderControl!
    
	func updateProgress(withValue value: Float) {
        self.sliderView.progress = value
    }
    
    func setTime(withPastTime pastTime: Float,
                 andRemainTime remainTime: Float) {
        DispatchQueue.main.async { [self] in
            self.pastLabel.text = self.intervalToString(TimeInterval(pastTime))
            self.remainLabel.text = intervalToString(TimeInterval(remainTime))
        }
    }
    
    override func initUI() {
        super.initUI()
        self.pastLabel.text = "00:00:00"
        self.remainLabel.text = "00:00:00"
        self.sliderView.progress = 0.0
    }
    
	private func intervalToString (_ interval: TimeInterval) -> String? {
		let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
		formatter.unitsStyle = .positional
		formatter.zeroFormattingBehavior = .pad
		formatter.maximumUnitCount = maximumUnitCount
		return formatter.string(from: interval)
	}
}

extension PlayerSlider: CustomSliderControlDelegate {
    
    func customSliderControl(_ customSliderControl: CustomSliderControl,
                             onSliderValueChanged progress: Float) {
        self.delegate?.playerSlider(self,
                                    onSliderValueChanged: progress)
    }
    
    func customSliderControl(_ customSliderControl: CustomSliderControl,
                             rewindPlayerOnSliderValue progress: Float) {
        self.delegate?.playerSlider(self,
                                    rewindPlayerOnSliderValue: progress)
    }
    
    func customSliderControlBeganChange(_ customSliderControl: CustomSliderControl) {
        self.delegate?.playerSliderValueBeganChange(self)
    }
}
