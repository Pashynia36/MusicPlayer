//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Pavlo Novak on 4/2/18.
//  Copyright © 2018 Pavlo Novak. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // initializing vars
    var positionOfSong: Int = 0
    var mp3Player: MP3Player?
    var mp4Player: MP4Player?
    var timer: Timer?
    var playVar = false
    var myMediaModel: [MediaModel]? = []
    var songLength: Double = 0.0
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var videoView: UIView!
    let image = UIImage(named: "tint")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Gesture for video
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        self.videoView.addGestureRecognizer(gesture)
        // Smaller thumb of progress of song
        progressBar.setThumbImage(image, for: .normal)
        mp3Player = MP3Player()
        mp4Player = MP4Player()
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
        cell.prepareMusicForMe(isPlaying: myMediaModel![indexPath.row] as! MusicModel)
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
        if myMediaModel != nil {
            myMediaModel![positionOfSong].isPlayingNow = false
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
        if myMediaModel != nil {
            myMediaModel![positionOfSong].isPlayingNow = false
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
        progressBar.value = Float(currentTime! / songLength)
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
        if myMediaModel != nil {
            myMediaModel![positionOfSong].isPlayingNow = true
        }
        animateMyCell()
    }
    
    // Initializing the array of music
    func getThemMusic() {
        
        for i in 0..<(mp3Player?.tracks.count)! {
            myMediaModel?.append(MusicModel(isPlayingNow: false, musicUrl: (mp3Player?.getTrackNameForTable(index: i))!))
        }
        for i in 0..<(mp4Player?.videos.count)! {
            myMediaModel?.append(VideoModel(isPlayingNow: false, videoUrl: (mp4Player?.getVideoNameForTable(index: i))!))
        }
    }
    
    func animateMyCell() {
        
        UIView.animate(withDuration: 1.0) {
            self.tableView.cellForRow(at: IndexPath(row: self.positionOfSong, section: 0))?.backgroundColor = UIColor.lightGray
            print(IndexPath(row: self.positionOfSong, section: 0))
        }
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        let playerLayer = AVPlayerLayer(player: mp4Player?.videoPlayer)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        mp4Player?.play()
    }
    
    @objc func checkAction(sender: UITapGestureRecognizer) {
        
        let videoPlayer = AVPlayerViewController()
        videoPlayer.player = mp4Player?.videoPlayer
        present(videoPlayer, animated: true, completion: nil)
    }
}


