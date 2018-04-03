//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/2/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // initializing vars
    var positionOfSong: Int = 0
    var mp3Player: MP3Player?
    var timer: Timer?
    var playVar = false
    var myMusicModel: [MusicModel]? = []
    var songLength: Double = 0.0
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var tableView: UITableView!
    let image = UIImage(named: "tint")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Smaller thumb of progress of song
        progressBar.setThumbImage(image, for: .normal)
        mp3Player = MP3Player()
        // Getting array of music names
        getThemMusic()
        setupNotificationCenter()
        // Setting up name of song to view
        setName()
        // Initializing duration of firstSong
        songLength = (mp3Player?.getFullSongTime())!
        updateViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mp3Player!.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "music") as! MusicTableViewCell
        cell.prepareMusicForMe(music: myMusicModel![indexPath.row])
        return cell
    }
    
    @IBAction func playSong(sender: AnyObject) {
        
        mp3Player?.play()
        if !playVar {
            startTimer()
            playVar = true
        } else {
            timer?.invalidate()
            playVar = false
        }
        setNewSong()
    }
    
    @IBAction func playNextSong(sender: AnyObject) {
        
        mp3Player?.nextSong(songFinishedPlaying: false)
        nextSong()
    }
    
    func nextSong() {
        
        startTimer()
        if myMusicModel != nil {
            myMusicModel![positionOfSong].isPlayingNow = false
            tableView.reloadData()
        }
        positionOfSong += 1
        if positionOfSong == mp3Player?.tracks.count {
            positionOfSong = 0
        }
        setNewSong()
    }
    
    // MARK:- Demo of song selection
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        mp3Player?.currentTrackIndex = indexPath.row
//        mp3Player?.queueTrack()
//        mp3Player?.play()
//    }
    
    @IBAction func setVolume(sender: UISlider) {
        
        mp3Player?.setVolume(volume: sender.value)
    }
    
    @IBAction func playPreviousSong(sender: AnyObject) {
        
        mp3Player?.previousSong()
        startTimer()
        if myMusicModel != nil {
            myMusicModel![positionOfSong].isPlayingNow = false
            tableView.reloadData()
        }
        positionOfSong += -1
        if positionOfSong < 0 {
            positionOfSong = (mp3Player?.tracks.count)! - 1
        }
        setNewSong()
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateViewsWithTimer(theTimer:)), userInfo: nil, repeats: true)
    }
    
    @objc func updateViewsWithTimer(theTimer: Timer) {
        
        updateViews()
    }
    
    func updateViews() {
        
        //Updating time & progress
        trackTime.text = mp3Player?.getCurrentTimeAsString()
        let currentTime = mp3Player?.getProgress()
        progressBar.value = Float(1.0 / (songLength/currentTime!))
        if progressBar.value == 1.0 {
            mp3Player?.nextSong(songFinishedPlaying: true)
            nextSong()
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
    
    // Function to scroll current music
    @IBAction func progressBarAction(_ sender: UISlider) {
        
        let fullTime = Float((mp3Player?.getFullSongTime())!)
        let moveTo = sender.value
        progressBar.value = (fullTime * moveTo)
        mp3Player?.changeTime(newTime: Double(moveTo*fullTime))
        updateViews()
    }
    
    // Setting new value for model & taking the duration
    func setNewSong() {
        
        songLength = (mp3Player?.getFullSongTime())!
        if myMusicModel != nil {
            myMusicModel![positionOfSong].isPlayingNow = true
        }
        animateMyCell()
    }
    
    // Initializing the array of music
    func getThemMusic() {
        
        for i in 0..<(mp3Player?.tracks.count)! {
            myMusicModel?.append(
                MusicModel(musicSong: (mp3Player?.getTrackNameForTable(index: i))!,
                           isPlayingNow: false))
        }
    }
    
    func animateMyCell() {
        
        UIView.animate(withDuration: 1.0) {
            self.tableView.cellForRow(at: IndexPath(row: self.positionOfSong, section: 0))?.backgroundColor = UIColor.lightGray
            print(IndexPath(row: self.positionOfSong, section: 0))
        }
    }
}


