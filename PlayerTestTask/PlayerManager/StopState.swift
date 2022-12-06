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
    
    func managerPlay(_ manager: PlayerManagerContext) {
        manager.setState(PlayState.shared)
        manager.play()
    }
    
    func managerStop(_ manager: PlayerManagerContext) {
    }
    
    func managerPause(_ manager: PlayerManagerContext) {
        manager.setState(PauseState.shared)
        manager.pause()
    }
    
    func manager(_ manager: PlayerManagerContext,
                 playTrackWithIndex trackIndex: Int) {
        manager.setState(PlayState.shared)
        manager.play(trackWithIndex: trackIndex)
    }
    
    func managerNextTrackSelected(_ manager: PlayerManagerContext) {
        manager.changeOnNextTrack()
    }
    
    func managerPreviousTrackSelected(_ manager: PlayerManagerContext) {
        manager.changeOnPreviousTrack()
    }
    
    func manager(_ manager: PlayerManagerContext,
                 rewindTrackWithPercentage percentage: Float) {
        manager.rewindTrack(with: percentage)
    }
}
