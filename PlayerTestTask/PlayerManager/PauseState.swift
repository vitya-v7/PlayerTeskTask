//
//  PauseState.swift
//  PlayerTestTask
//
//  Created by Admin on 30.11.2022.
//

import Foundation

class PauseState: PlayerStateProtocol {
    
    static let shared = PauseState()
    private init() {}
    
    
    func managerPlay(_ manager: PlayerManager) {
        manager.setState(PlayState.shared)
        manager.play()
    }
    
    func managerStop(_ manager: PlayerManager) {
        manager.setState(StopState.shared)
        manager.stop()
    }
    
    func managerPause(_ manager: PlayerManager) {
    }
    
    func manager(_ manager: PlayerManager,
                 playTrackWithIndex trackIndex: Int) {
        manager.setState(PlayState.shared)
        manager.play(trackWithIndex: trackIndex)
    }
    
    func managerNextTrackSelected(_ manager: PlayerManager) {
        manager.setState(StopState.shared)
        manager.stop()
        manager.changeOnNextTrack()
    }
    
    func managerPreviousTrackSelected(_ manager: PlayerManager) {
        manager.setState(StopState.shared)
        manager.stop()
        manager.changeOnPreviousTrack()
    }
    
    func manager(_ manager: PlayerManager,
                 rewindTrackWithPercentage percentage: Float) {
        manager.rewindTrack(with: percentage)
    }
}
