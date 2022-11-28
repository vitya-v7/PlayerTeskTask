//
//  TracksListViewController.swift
//  PlayerTestTask
//
//  Created by Admin on 25.11.2022.
//

import Foundation
import UIKit

protocol TracksListViewInput: AnyObject {
    
}

protocol TracksListViewOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
}

class TracksListViewController: UIViewController, TracksListViewInput {
    @IBOutlet var tableView: UITableView!
    var output: TracksListViewOutput?
    static let storyboardIdentifier = "TrackListControllerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 40
        self.setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    private func setupNavBar() {
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(named: "navBarColor")
        
        let backImage = UIImage(named: "backBtn")
        navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor(named: "appGreenColor")
        
        addNavBarImage(withTitle: "Playlist")
    }
    
}
