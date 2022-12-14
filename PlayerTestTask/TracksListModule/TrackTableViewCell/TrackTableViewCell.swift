//
//  TrackTableViewCell.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak private var musicNoteImage: UIImageView!
    @IBOutlet weak private var trackLabel: UILabel!
    @IBOutlet weak private var trackDutationLabel: UILabel!
    
    func configure(with track: TrackModel) {
        trackLabel.text = track.title
        trackDutationLabel.text = track.duration
        musicNoteImage.highlightedImage = UIImage(named: "soundIcon Active")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.setHighlighted(true,
                                animated: true)
        } else {
            self.setHighlighted(false,
                                animated: true)
        }
    }
    
}
