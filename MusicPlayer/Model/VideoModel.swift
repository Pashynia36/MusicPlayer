//
//  VideoModel.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/3/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation

class VideoModel: MediaModel {
    
    var videoUrl: String
    
    init(isPlayingNow: Bool, videoUrl: String) {
        self.videoUrl = videoUrl
        super.init(isPlayingNow: isPlayingNow)
    }
}
