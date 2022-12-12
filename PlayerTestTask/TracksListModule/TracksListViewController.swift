//
//  TracksListViewController.swift
//  PlayerTestTask
//
//  Created by Admin on 25.11.2022.
//

import Foundation
import UIKit

protocol TracksListViewInput: UIViewController {
    func setupNavigationBar()
    func setTableRowHeight(_ height: Float)
    func reloadTableView()
    func selectCellWithIndexPath(_ indexPath: IndexPath)
}

protocol TracksListViewOutput {
    func viewDidLoadDone()
    func viewWillAppearDone()
    func viewDidAppearDone()
    func tracksCount() -> Int
    func getTrack(withIndex: Int) -> TrackModel?
    func rowDidSelected(atIndexPath indexPath: IndexPath)
    func openItunesClicked()
    func openGalleryClicked()
    func openFilesClicked()
    var selectedRow: Int { get }
}

class TracksListViewController: UIViewController, TracksListViewInput {
    @IBOutlet var tableView: UITableView!
    var output: TracksListViewOutput?
    static let storyboardIdentifier = "TrackListControllerID"
    
    @IBOutlet weak var itunesButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var filesButton: UIButton!
    
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
        self.itunesButton.layer.cornerRadius = 8.0
        self.galleryButton.layer.cornerRadius = 8.0
        self.filesButton.layer.cornerRadius = 8.0
        self.output?.viewDidLoadDone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output?.viewWillAppearDone()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.output?.viewDidAppearDone()
    }
    
    func selectCellWithIndexPath(_ indexPath: IndexPath) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.selectCellWithIndexPath(indexPath)
            }
            return
        }
        self.tableView.selectRow(at: indexPath,
                                 animated: false,
                                 scrollPosition: .none)
    }
    
    func setupNavigationBar() {
        if !Thread.current.isMainThread {
            DispatchQueue.main.async {
                self.setupNavigationBar()
            }
            return
        }
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(named: "navBarColor")
        
        let backImage = UIImage(named: "backBtn")
        navBarAppearance.setBackIndicatorImage(backImage,
                                               transitionMaskImage: backImage)
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = UIColor(named: "appGreenColor")
        
        self.navigationItem.title = "Playlist"
    }
    
    func setTableRowHeight(_ height: Float) {
        DispatchQueue.main.async {
            self.tableView.rowHeight = CGFloat(height)
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        cell.setHighlighted(output.selectedRow == indexPath.item,
                            animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.output?.rowDidSelected(atIndexPath: indexPath)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
