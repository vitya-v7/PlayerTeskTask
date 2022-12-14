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
    var goToItunesScreen: ((MusicFilesHelper) -> Void)?
    var goToGalleryScreen: ((GalleryHelper) -> Void)?
    var goToFilesScreen: ((FilesAppHelper) -> Void)?
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
        self.view?.setupNavigationBar()
    }
    
    func viewWillAppearDone() {
        guard self.playerManager.isPlaying() else {
            return
        }
        if (0 ..< self.playerManager.getTracksCount()).contains(self.playerManager.trackCurrentIndex) {
            self.view?.selectCellWithIndexPath(IndexPath(item: self.playerManager.trackCurrentIndex,
                                                         section: 0))
        }
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
    
    func getCurrentTrackIndex() -> Int {
        return self.playerManager.trackCurrentIndex
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
