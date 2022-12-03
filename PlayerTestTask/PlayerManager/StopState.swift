//
//  StopState.swift
//  PlayerTestTask
//
//  Created by Admin on 30.11.2022.
//

import Foundation

class StopState: PlayerStateProtocol {
    
    static let shared = StopState()
    private init() {}
    
    func managerPlay(_ manager: PlayerManager) {
        manager.setState(PlayState.shared)
        manager.play()
    }
    
    func managerStop(_ manager: PlayerManager) {
    }
    
    func managerPause(_ manager: PlayerManager) {
        manager.setState(PauseState.shared)
        manager.pause()
    }
    
    func manager(_ manager: PlayerManager,
                 playTrackWithIndex trackIndex: Int) {
        manager.setState(PlayState.shared)
        manager.play(trackWithIndex: trackIndex)
    }
    
    func managerNextTrackSelected(_ manager: PlayerManager) {
        manager.changeOnNextTrack()
    }
    
    func managerPreviousTrackSelected(_ manager: PlayerManager) {
        manager.changeOnPreviousTrack()
    }
    
    func manager(_ manager: PlayerManager,
                 rewindTrackWithPercentage percentage: Float) {
        manager.rewindTrack(with: percentage)
    }
}
