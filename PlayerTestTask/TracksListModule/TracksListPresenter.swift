//
//  TracksListPresenter.swift
//  PlayerTestTask
//
//  Created by Admin on 25.11.2022.
//

import Foundation

class TracksListPresenter: TracksListViewOutput {
    weak var view: TracksListViewInput?
   
    
    var goToTrackPlayerScreen: ((TrackModel) -> Void)?
    
    func viewDidLoadDone() {
    }
    
    func viewDidAppearDone() {
        
    }
    
    func tracksCount() -> Int {
        return DataManager.shared.getUrls().count
    }
    
    func getTrack(withIndex index: Int) -> TrackModel? {
        PlayerManager.shared.getTrack(withIndex: index)
    }
}
