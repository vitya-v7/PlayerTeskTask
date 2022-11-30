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
    func tracksCount() -> Int
    func getTrack(withIndex: Int) -> TrackModel?
}

class TracksListViewController: UIViewController, TracksListViewInput {
    @IBOutlet var tableView: UITableView!
    var output: TracksListViewOutput?
    static let storyboardIdentifier = "TrackListControllerID"
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 40
        self.setupNavBar()
        self.output?.viewDidLoadDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
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
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            tableView.visibleCells.forEach { cell in
                if cell == selectedCell && cell.isSelected {
                    cell.setHighlighted(true, animated: true)
                } else {
                    cell.setHighlighted(false, animated: true)
                }
            }
        }
    }
}
