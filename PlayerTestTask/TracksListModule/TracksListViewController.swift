//
//  TracksListViewController.swift
//  PlayerTestTask
//
//  Created by Admin on 25.11.2022.
//

import Foundation
import UIKit

protocol TracksListViewInput: UIViewController {
    func setupNavBar()
    func setTableRowHeight(_ height: Float)
}

protocol TracksListViewOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
    func tracksCount() -> Int
    func getTrack(withIndex: Int) -> TrackModel?
    func rowDidSelected(atIndexPath indexPath: IndexPath)
    func openItunesClicked()
    func openGalleryClicked()
    func openFilesClicked()
}

class TracksListViewController: UIViewController, TracksListViewInput {
    @IBOutlet var tableView: UITableView!
    var output: TracksListViewOutput?
    static let storyboardIdentifier = "TrackListControllerID"
     
    @IBAction func openItunes(_ sender: Any) {
        self.output?.openItunesClicked()
    }
    
    @IBAction func openGallery(_ sender: Any) {
        self.output?.openGalleryClicked()
    }
    
    @IBAction func openFiles(_ sender: Any) {
        self.output?.openFilesClicked()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output?.viewDidLoadDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
    }
    
    func setupNavBar() {
        if !Thread.current.isMainThread {
            DispatchQueue.main.async {
                self.setupNavBar()
            }
            return
        }
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
    
    func setTableRowHeight(_ height: Float) {
        DispatchQueue.main.async {
            self.tableView.rowHeight = CGFloat(height)
        }
    }
    
}

extension TracksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height / 10.0
    }
}

extension TracksListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let output = self.output else {
            return 0
        }
        return output.tracksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "trackCell",
                for: indexPath
            ) as? TrackTableViewCell, let output = self.output
        else { return UITableViewCell() }
        
        if let track = output.getTrack(withIndex: indexPath.item) {
            cell.configure(with: track)
        }
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "appGreenColor")
        cell.selectedBackgroundView = view
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.output?.rowDidSelected(atIndexPath: indexPath)
    }
}
