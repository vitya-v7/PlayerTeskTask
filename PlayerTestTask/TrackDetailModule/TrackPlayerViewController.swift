//
//  TrackPlayerViewController.swift
//  PlayerTestTask
//
//  Created by Admin on 29.11.2022.
//

import Foundation
import UIKit

protocol TrackPlayerViewInput: AnyObject {
}

protocol TrackPlayerViewOutput {
    func viewDidLoadDone()
    func viewDidAppearDone()
    func tracksCount() -> Int
    var tracks: [TrackModel] { get }
}

class TrackPlayerViewController: UIViewController {
    var output: TrackPlayerViewOutput?
    
}
