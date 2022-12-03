//
//  PlayerState.swift
//  PlayerTestTask
//
//  Created by Admin on 01.12.2022.
//

import AVFoundation

protocol PlayerManagerContext {
    func setState(_ playerState: PlayerStateProtocol)
}

protocol PlayerStateProtocol {
    func managerPlay(_ manager: PlayerManager)
    func managerStop(_ manager: PlayerManager)
    func managerPause(_ manager: PlayerManager)
    func manager(_ manager: PlayerManager,
                 playTrackWithIndex trackIndex: Int)
    func managerNextTrackSelected(_ manager: PlayerManager)
    func managerPreviousTrackSelected(_ manager: PlayerManager)
    func manager(_ manager: PlayerManager,
                 rewindTrackWithPercentage percentage: Float)
}
