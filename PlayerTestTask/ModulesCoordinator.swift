//
//  ModulesCoordinator.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import Foundation
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
        presenter.goToDetailInfoScreen = { trackInfoModel in
            self.goToDetailTrackInfoScreen(withTrackModel: trackInfoModel)
        }
        tracksListViewController.output = presenter
        self.navigationController?.pushViewController(tracksListViewController,
                                                     animated: false)
    }
    
    
    private func goToDetailTrackInfoScreen(withTrackModel trackModel: TrackModel) {
        
    }
}
