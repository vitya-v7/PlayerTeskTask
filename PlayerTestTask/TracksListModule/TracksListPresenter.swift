//
//  TracksListPresenter.swift
//  PlayerTestTask
//
//  Created by Admin on 25.11.2022.
//

import Foundation
import MediaPlayer

class TracksListPresenter: TracksListViewOutput {
    weak var view: TracksListViewInput?
   
    var goToTrackPlayerScreen: ((PlayerManager, Int) -> Void)?
    
    var goToItunesScreen: ((MPMediaPickerControllerDelegate) -> Void)?
    var goToGalleryScreen: ((GalleryDelegate) -> Void)?
    var goToFilesScreen: ((UIDocumentPickerDelegate) -> Void)?
    
    var playerManager: PlayerManager
    
    init() {
        
        self.playerManager = PlayerManager()
    }
    
    func viewDidLoadDone() {
        self.view?.setupNavBar()
    }
    
    func viewDidAppearDone() {
        
    }
    
    func tracksCount() -> Int {
        return self.playerManager.getTracksCount()
    }
    
    func getTrack(withIndex index: Int) -> TrackModel? {
        self.playerManager.getTrack(withIndex: index)
    }
    
    func rowDidSelected(atIndexPath indexPath: IndexPath) {
        self.goToTrackPlayerScreen?(self.playerManager, indexPath.item)
    }
    
    func openItunesClicked() {
        self.goToItunesScreen?(self)
    }
    
    func openGalleryClicked() {
        self.goToGalleryScreen?(self)
    }
    
    func openFilesClicked() {
        self.goToFilesScreen?(self)
    }
}

extension TracksListPresenter: MPMediaPickerControllerDelegate {
    
}
