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
    
    func managerPlay(_ manager: PlayerManagerContext) {}
    
    func managerStop(_ manager: PlayerManagerContext) {
        manager.setState(StopState.shared)
        manager.stop()
    }
    
    func managerPause(_ manager: PlayerManagerContext) {
        manager.setState(PauseState.shared)
        manager.pause()
    }
    
    func manager(_ manager: PlayerManagerContext,
                 playTrackWithIndex trackIndex: Int) {
        manager.play(trackWithIndex: trackIndex)
    }
    
    func managerNextTrackSelected(_ manager: PlayerManagerContext) {
        manager.changeOnNextTrack()
        manager.play()
    }
    
    func managerPreviousTrackSelected(_ manager: PlayerManagerContext) {
        manager.changeOnPreviousTrack()
        manager.play()
    }
    
    func manager(_ manager: PlayerManagerContext,
                 rewindTrackWithPercentage percentage: Float) {
        manager.rewindTrack(with: percentage)
    }
}
