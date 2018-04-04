//
//  VideoReader.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/4/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation

class VideoReader: NSObject {
    
    class func readVideo() -> [String] {
        
        return Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil)
    }
}
