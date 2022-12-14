//
//  PlayerState.swift
//  PlayerTestTask
//
//  Created by Admin on 01.12.2022.
//

import AVFoundation
import UIKit

protocol PlayerManagerContext {
    func setState(_ playerState: PlayerStateProtocol)
    func play(trackWithIndex trackIndex: Int)
    func changeOnNextTrack()
    func changeOnPreviousTrack()
    func play()
    func pause()
    func stop()
    func rewindTrack(with percentage: Float)
}

protocol PlayerStateProtocol {
    func managerPlay(_ manager: PlayerManagerContext)
    func managerPause(_ manager: PlayerManagerContext)
    func managerPlayPause(_ manager: PlayerManagerContext)
    func managerStop(_ manager: PlayerManagerContext)
    func manager(_ manager: PlayerManagerContext,
                 playTrackWithIndex trackIndex: Int)
    func managerNextTrackSelected(_ manager: PlayerManagerContext)
    func managerPreviousTrackSelected(_ manager: PlayerManagerContext)
    func manager(_ manager: PlayerManagerContext,
                 rewindTrackWithPercentage percentage: Float)
    func managerButtonImage(_ manager: PlayerManagerContext) -> UIImage?
}
