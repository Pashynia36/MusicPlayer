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
    
    func prepareMusicForMe(isPlaying: MusicModel) {
        
        musicLabel.text = isPlaying.musicUrl
        if isPlaying.isPlayingNow {
            self.backgroundColor = UIColor.lightGray
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}
