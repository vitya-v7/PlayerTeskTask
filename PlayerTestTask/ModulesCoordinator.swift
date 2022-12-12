//
//  ModulesCoordinator.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import Foundation
import MediaPlayer
import UIKit

final class ModulesCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTracksListScreen()
    }
    
    // MARK: - Private implementation
    private func showTracksListScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tracksListViewController = mainStoryboard.instantiateViewController(
            withIdentifier: TracksListViewController.storyboardIdentifier) as? TracksListViewController else {
                  return
              }
        
        let presenter = TracksListPresenter()
        presenter.view = tracksListViewController
        presenter.goToTrackPlayerScreen = { audioPlayerManager, index in
            self.showTrackPlayerScreen(withPlayerManager: audioPlayerManager,
                                       andTrackWithIndex: index)
        }
        presenter.goToFilesScreen = { helper in
            self.showDocumentPickerScreen(withDocumentDelegate: helper)
        }
        presenter.goToItunesScreen = { helper in
            self.showMediaPickerScreen(withMediaDelegate: helper)
        }
        presenter.goToGalleryScreen = { helper in
            self.showGalleryPickerScreen(withGalleryDelegate: helper)
        }
        tracksListViewController.output = presenter
        self.navigationController?.pushViewController(tracksListViewController,
                                                      animated: false)
    }
    
    private func showTrackPlayerScreen(withPlayerManager playerManager: PlayerManager,
                                       andTrackWithIndex index: Int) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tracksPlayerViewController = mainStoryboard.instantiateViewController(
            withIdentifier: TrackPlayerViewController.storyboardIdentifier) as? TrackPlayerViewController else {
                return
            }
        
        let presenter = TrackPlayerPresenter(withPlayerManager: playerManager,
                                             andIndex: index)
        presenter.view = tracksPlayerViewController
        tracksPlayerViewController.output = presenter
        self.navigationController?.pushViewController(tracksPlayerViewController,
                                                      animated: false)
    }
    
    func showDocumentPickerScreen(withDocumentDelegate documentDelegate: FilesAppHelper) {
        DispatchQueue.main.async {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
            documentPicker.delegate = documentDelegate
            documentPicker.allowsMultipleSelection = false
            self.navigationController?.present(documentPicker,
                                               animated: true)
        }
    }
    
    func showMediaPickerScreen(withMediaDelegate mediaDelegate: MusicFilesHelper) {
        DispatchQueue.main.async {
            guard let topController = self.navigationController?.topViewController else {
                return
            }
            mediaDelegate.requestItemsInViewController(inViewController: topController) {
                let mediaPicker = MPMediaPickerController()
                mediaPicker.delegate = mediaDelegate
                mediaPicker.allowsPickingMultipleItems = false
                DispatchQueue.main.async {
                    self.navigationController?.present(mediaPicker,
                                                       animated: false)
                }
            }
        }
    }
    
    func showGalleryPickerScreen(withGalleryDelegate galleryDelegate: GalleryHelper) {
        DispatchQueue.main.async {
            guard let topController = self.navigationController?.topViewController else {
                return
            }
            galleryDelegate.requestItemsInViewController(inViewController: topController) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .savedPhotosAlbum
                imagePickerController.delegate = galleryDelegate
                imagePickerController.mediaTypes = ["public.movie"]
                DispatchQueue.main.async {
                    self.navigationController?.present(imagePickerController,
                                                       animated: true,
                                                       completion: nil)
                }
            }
        }
    }
}
