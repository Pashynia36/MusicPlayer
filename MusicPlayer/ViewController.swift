//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/2/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var mp3Player: MP3Player?
    var timer: Timer?
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    let image = UIImage(named: "tint")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        progressBar.setThumbImage(image, for: .normal)
        mp3Player = MP3Player()
        setupNotificationCenter()
        setName()
        updateViews()
    }
    
    @IBAction func playSong(sender: AnyObject) {
        
        mp3Player?.play()
        startTimer()
    }
    
    @IBAction func stopSong(sender: AnyObject) {
        
        mp3Player?.stop()
        updateViews()
        timer?.invalidate()
    }
    
    @IBAction func playNextSong(sender: AnyObject) {
        
        mp3Player?.nextSong(songFinishedPlaying: false)
        startTimer()
    }
    
    
    @IBAction func setVolume(sender: UISlider) {
        
        mp3Player?.setVolume(volume: sender.value)
    }
    
    @IBAction func playPreviousSong(sender: AnyObject) {
        
        mp3Player?.previousSong()
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateViewsWithTimer(theTimer:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewsWithTimer(theTimer: Timer) {
        
        updateViews()
    }
    
    func updateViews() {
        
        trackTime.text = mp3Player?.getCurrentTimeAsString()
        if let progress = mp3Player?.getProgress() {
            progressBar.value = progress
        }
    }
    
    @objc func setName() {
        trackName.text = mp3Player?.getCurrentTrackName()
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setName),
            name:NSNotification.Name(rawValue: "SetTrackNameText"),
            object:nil)
    }
    @IBAction func progressBarAction(_ sender: UISlider) {
        
        let fullTime = Float((mp3Player?.getFullSongTime())!)
        let moveTo = sender.value
        progressBar.value = 1.0 / (fullTime * moveTo)
        mp3Player?.changeTime(newTime: Double(moveTo*fullTime))
        updateViews()
    }
}

