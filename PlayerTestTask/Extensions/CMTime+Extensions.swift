//
//  CMTime+Extensions.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import Foundation
import AVFoundation

extension CMTime {
    
    func displayStringValue() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormatString
    }
}
