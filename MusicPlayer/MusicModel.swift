//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/3/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation

class MusicModel {
    
    var musicSong: String
    var isPlayingNow: Bool
    
    init(musicSong: String, isPlayingNow: Bool) {
        
        self.musicSong = musicSong
        self.isPlayingNow = isPlayingNow
    }
}
