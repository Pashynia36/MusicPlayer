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
    
    var player: AVAudioPlayer?
    var currentTrackIndex = 0
    var tracks = [String]()
    
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
            player = try AVAudioPlayer(contentsOf: url as URL)
        } catch {
            print(error)
        }
        if let hasError = error {
            print(hasError)
        } else {
            player?.delegate = self
            player?.prepareToPlay()
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: "SetTrackNameText"),
                object: nil)
        }
    }
    
    func play() {
        
        if player?.isPlaying == false {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func stop() {
        
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    
    func nextSong(songFinishedPlaying: Bool) {
        
        var playerWasPlaying = false
        if player?.isPlaying == true{
            player?.stop()
            playerWasPlaying = true
        }
        
        currentTrackIndex += 1
        if currentTrackIndex >= tracks.count {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player?.play()
        }
    }
    
    func previousSong() {
        
        var playerWasPlaying = false
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        currentTrackIndex += -1
        if currentTrackIndex < 0 {
            currentTrackIndex = tracks.count - 1
        }
        
        queueTrack()
        if playerWasPlaying {
            player?.play()
        }
    }
    
    func getCurrentTrackName() -> String {
        
        let trackName = tracks[currentTrackIndex]
        let theFileName = (trackName as NSString).lastPathComponent
        return theFileName
    }
    
    func getCurrentTimeAsString() -> String {
        
        var seconds = 0
        var minutes = 0
        if let time = player?.currentTime {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    func getFullSongTime() -> Double {
    
        let url = NSURL.init(fileURLWithPath: tracks[currentTrackIndex] as String)
        let asset = AVURLAsset(url: url as URL)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        return durationInSeconds
    }
    
    func changeTime(newTime: Double) {
        
        player?.currentTime = newTime
    }
    
    func getProgress() -> Float {
        
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        guard let currentTime = player?.currentTime, let duration = player?.duration else {
            return 0.0
        }
        theCurrentTime = currentTime
        theCurrentDuration = duration
        return Float(theCurrentTime/theCurrentDuration)
    }
    
    func setVolume(volume: Float) {
        
        player?.volume = volume
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            nextSong(songFinishedPlaying: true)
        }
    }
}
