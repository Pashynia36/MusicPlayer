//
//  MusicTableViewCell.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/2/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var musicLabel: UILabel!
    var isPlaying: Bool = false

    func prepareMusicForMe(music: MP3Player, index: Int, isPlaying: Bool) {
        
        musicLabel.text = music.getTrackNameForTable(index: index)
        // Needs to set "selected"
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
