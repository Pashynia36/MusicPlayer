//
//  MP4Player.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/4/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation
import AVFoundation

class MP4Player: NSObject {
    
    var videoPlayer: AVPlayer?
    var currentVideoIndex = 0
    var videos = [String]()
    var item: AVPlayerItem?
    var isPlaying: Bool = false
    
    override init() {
        
        videos = VideoReader.readVideo()
        super.init()
        queueTrack()
    }
    
    
    func queueTrack() {
        
        if videoPlayer != nil {
            videoPlayer = nil
        }
        var error: NSError?
        let url = NSURL.init(fileURLWithPath: videos[currentVideoIndex] as String)
        do {
            videoPlayer = AVPlayer(url: url as URL)
            item = AVPlayerItem(url: url as URL)
        }
        if let hasError = error {
            print(hasError)
            error = nil
        } else {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "SetTrackNameText"),
                object: nil)
        }
    }
    
    func play() {
        
        if isPlaying == false {
            videoPlayer?.play()
            isPlaying = true
        } else {
            videoPlayer?.pause()
            isPlaying = false
        }
    }
    
    func getVideoNameForTable(index: Int) -> String {
        
        let videoName = videos[index]
        let theVideoName = (videoName as NSString).lastPathComponent
        return theVideoName
    }
}
