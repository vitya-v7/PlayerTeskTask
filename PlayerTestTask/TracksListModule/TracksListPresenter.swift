//
//  TracksListPresenter.swift
//  PlayerTestTask
//
//  Created by Admin on 25.11.2022.
//

import Foundation

class TracksListPresenter: TracksListViewOutput {
    weak var view: TracksListViewInput?
    
    private var tracks: [TrackModel] = []
    var goToDetailInfoScreen: ((TrackModel) -> Void)?
    func viewDidLoadDone() {
        self.tracks = self.getTracks()
    }
    
    func viewDidAppearDone() {
        
    }
    
    func getTracks() -> [TrackModel] {
        var tracks = [TrackModel]()
        
        let urls = DataManager.shared.getUrls()
        let fileNames = DataManager.shared.getFileNames(by: urls)
        let durations = DataManager.shared.getSongDurations(by: urls)
        
        for index in 0...(fileNames.count - 1) {
            
            tracks.append(TrackModel(title: fileNames[index],
                                     duration: durations[index]))
            
        }
        
        return tracks
    }
}
