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
    var itunesHelper = MusicFilesHelper()
    var appFilesHelper = FilesAppHelper()
    var galleryHelper = GalleryHelper()
    var playerManager: PlayerManager
    
    init() {
        self.playerManager = PlayerManager()
        self.appFilesHelper.delegate = self
        self.galleryHelper.delegate = self
        self.itunesHelper.delegate = self
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
        self.goToItunesScreen?(self.itunesHelper)
    }
    
    func openGalleryClicked() {
        self.goToGalleryScreen?(self.galleryHelper)
    }
    
    func openFilesClicked() {
        self.goToFilesScreen?(self.appFilesHelper)
    }
}

extension TracksListPresenter: GalleryHelperDelegate {
    func galleryHelper(_ galleryHelper: GalleryHelper,
                       itemsHasBeenChanged items: [TrackModel]) {
        playerManager.addTracks(withModels: items)
        self.view?.reloadTableView()
    }
}

extension TracksListPresenter: MusicFilesHelperDelegate {
    func itunesHelper(_ itunesHelper: MusicFilesHelper,
                      itemsHasBeenChanged items: [TrackModel]) {
        playerManager.addTracks(withModels: items)
        self.view?.reloadTableView()
    }
}

extension TracksListPresenter: FilesAppHelperDelegate {
    func appFilesHelper(_ appFilesHelper: FilesAppHelper,
                        itemsHasBeenChanged items: [TrackModel]) {
        playerManager.addTracks(withModels: items)
        self.view?.reloadTableView()
    }
}
