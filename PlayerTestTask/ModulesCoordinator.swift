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
    
    func showDocumentPickerScreen(withDocumentDelegate documentDelegate: UIDocumentPickerDelegate) {
        DispatchQueue.main.async {
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
            documentPicker.delegate = documentDelegate
            documentPicker.allowsMultipleSelection = false
            self.navigationController?.present(documentPicker,
                                               animated: true)
        }
    }
    
    func showMediaPickerScreen(withMediaDelegate mediaDelegate: MPMediaPickerControllerDelegate) {
        DispatchQueue.main.async {
            let mediaPicker = MPMediaPickerController()
            mediaPicker.delegate = mediaDelegate
            mediaPicker.allowsPickingMultipleItems = false
            self.navigationController?.present(mediaPicker,
                                              animated: false)
        }
    }
    
    func showGalleryPickerScreen(withGalleryDelegate galleryDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.delegate = galleryDelegate
            imagePickerController.mediaTypes = ["public.movie"]
            self.navigationController?.present(imagePickerController, animated: true, completion: nil)
        }
    }
}
