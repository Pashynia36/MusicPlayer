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
    
    var positionOfSong: Int = 0
    var mp3Player: MP3Player?
    var timer: Timer?
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var tableView: UITableView!
    let image = UIImage(named: "tint")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        progressBar.setThumbImage(image, for: .normal)
        mp3Player = MP3Player()
        setupNotificationCenter()
        setName()
        updateViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mp3Player!.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "music")
        cell?.textLabel?.text = mp3Player?.getTrackNameForTable(index: indexPath.row)
        return cell!
    }
    
    @IBAction func playSong(sender: AnyObject) {
        
        mp3Player?.play()
        startTimer()
        setMeSelected()
    }
    
    @IBAction func stopSong(sender: AnyObject) {
        
        mp3Player?.stop()
        updateViews()
        timer?.invalidate()
    }
    
    @IBAction func playNextSong(sender: AnyObject) {
        
        mp3Player?.nextSong(songFinishedPlaying: false)
        startTimer()
        tableView.deselectRow(at:
            IndexPath(row: positionOfSong, section: 0),
            animated: true)
        positionOfSong += 1
        if positionOfSong == mp3Player?.tracks.count {
            positionOfSong = 0
        }
        setMeSelected()
    }
    
    
    @IBAction func setVolume(sender: UISlider) {
        
        mp3Player?.setVolume(volume: sender.value)
    }
    
    @IBAction func playPreviousSong(sender: AnyObject) {
        
        mp3Player?.previousSong()
        startTimer()
        tableView.deselectRow(at:
            IndexPath(row: positionOfSong, section: 0),
                              animated: true)
        positionOfSong += -1
        if positionOfSong < 0 {
            positionOfSong = (mp3Player?.tracks.count)! - 1
        }
        setMeSelected()
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
            progressBar.value = Float(progress)
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
        progressBar.value = (fullTime * moveTo)
        mp3Player?.changeTime(newTime: Double(moveTo*fullTime))
        updateViews()
    }
    
    func setMeSelected() {
        
        tableView.reloadData()
        tableView.cellForRow(at: IndexPath.init(row: positionOfSong, section: 0))?.isSelected = true
    }
}


