//
//  MP3Player.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/2/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import Foundation
import AVFoundation

class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player: AVPlayer?
    var currentTrackIndex = 0
    var tracks = [String]()
    var item: AVPlayerItem?
    var isPlaying: Bool = false
    
    override init() {
        
        tracks = FileReader.readFiles()
        super.init()
        queueTrack()
    }
    
    func queueTrack() {
        
        if player != nil {
            player = nil
        }
        var error: NSError?
        let url = NSURL.init(fileURLWithPath: tracks[currentTrackIndex] as String)
        do {
            player = AVPlayer(url: url as URL)
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
            player?.play()
            isPlaying = true
        } else {
            player?.pause()
            isPlaying = false
        }
    }
    
    func nextSong(songFinishedPlaying: Bool) {
        
        var playerWasPlaying = songFinishedPlaying
        if isPlaying == true{
            player?.pause()
            isPlaying = false
            playerWasPlaying = true
        }
        
        currentTrackIndex += 1
        if currentTrackIndex > tracks.count - 1 {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || isPlaying {
            player?.play()
            isPlaying = true
        }
    }
    
    func previousSong() {
        
        var playerWasPlaying = false
        if isPlaying {
            player?.pause()
            isPlaying = false
            playerWasPlaying = true
        }
        currentTrackIndex += -1
        if currentTrackIndex < 0 {
            currentTrackIndex = tracks.count - 1
        }
        queueTrack()
        if playerWasPlaying {
            player?.play()
            isPlaying = true
        }
    }
    
    func getTrackNameForTable(index: Int) -> String {
        
        let trackName = tracks[index]
        let theFileName = (trackName as NSString).lastPathComponent
        return theFileName
    }
    
    func getCurrentTrackName() -> String {
        
        let trackName = tracks[currentTrackIndex]
        let theFileName = (trackName as NSString).lastPathComponent
        return theFileName
    }
    
    func getCurrentTimeAsString() -> String {
        
        var seconds = 0.0
        var minutes = 0.0
        let time = player?.currentTime()
        seconds = Double(Int((time?.seconds)!) % 60)
        minutes = Double(Int((time?.seconds)! / 60) % 60)
        return String(format: "%0.2d:%0.2d", Int(minutes), Int(seconds))
    }
    
    func getFullSongTime() -> Double {
    
        let url = NSURL.init(fileURLWithPath: tracks[currentTrackIndex] as String)
        let asset = AVURLAsset(url: url as URL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        return durationInSeconds
    }
    
    func changeTime(newTime: Double) {
        
        let myCMTime = CMTimeMake(Int64(Int(newTime)), 1)
        player?.seek(to: myCMTime)
    }
    
    func getProgress() -> Double {
        
        var theCurrentTime: CMTime
        let currentTime = player?.currentTime()
        theCurrentTime = currentTime!
        return Double(theCurrentTime.seconds)
    }
    
    func setVolume(volume: Float) {
        
        player?.volume = volume
    }
}
