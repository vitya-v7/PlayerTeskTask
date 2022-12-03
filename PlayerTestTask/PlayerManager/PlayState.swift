//
//  PlayState.swift
//  PlayerTestTask
//
//  Created by Admin on 30.11.2022.
//

import Foundation

class PlayState: PlayerStateProtocol {
    
    static let shared = PlayState()
    private init() {}
    
    func managerPlay(_ manager: PlayerManager) {}
    
    func managerStop(_ manager: PlayerManager) {
        manager.setState(StopState.shared)
        manager.stop()
    }
    
    func managerPause(_ manager: PlayerManager) {
        manager.setState(PauseState.shared)
        manager.pause()
    }
    
    func manager(_ manager: PlayerManager,
                 playTrackWithIndex trackIndex: Int) {
        manager.play(trackWithIndex: trackIndex)
    }
    
    func managerNextTrackSelected(_ manager: PlayerManager) {
        manager.changeOnNextTrack()
        manager.play()
    }
    
    func managerPreviousTrackSelected(_ manager: PlayerManager) {
        manager.changeOnPreviousTrack()
        manager.play()
    }
    
    func manager(_ manager: PlayerManager,
                 rewindTrackWithPercentage percentage: Float) {
        manager.rewindTrack(with: percentage)
    }
}
