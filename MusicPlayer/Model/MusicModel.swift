//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/3/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation

class MusicModel: MediaModel {
    
    var musicUrl: String
    
    init(isPlayingNow: Bool, musicUrl: String) {
        self.musicUrl = musicUrl
        super.init(isPlayingNow: isPlayingNow)
    }
}











