//
//  ViewController.swift
//  HoldOut
//
//  Created by Adam Chisolm on 3/30/19.
//  Copyright © 2019 Adam Chisolm. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var timerLabel: UILabel!
    
    let saveData = UserDefaults.standard
    
    // The game only starts once both players are touching their buttons
    var player1Touch = false
    var player2Touch = false
    var gameStarted = false
    
    // Used to make game timer
    var startTime = TimeInterval()
    var timer = Timer()
    
    // High score
    let prevBest = UILabel()
    
    // Buttons the players touch to start game
    let button = UIButton(type: .custom)
    let p2Button = UIButton(type: .custom)
    
    // Main music theme
    var music: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func getHighScore() -> String {
        let highScore = saveData.string(forKey: "highScore")
        
        return highScore ?? "00:00:00"
    }
    
    func deleteHighScore() {
        saveData.removeObject(forKey: "highScore")
    }
    
    func setHighScore(newHighScore: String) {
        saveData.set(newHighScore, forKey: "highScore")
    }
    
    
    func startGame() {
        gameStarted = true
        startTime = Date.timeIntervalSinceReferenceDate
        
        // Start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
        
        // Play music and vibrate to let players know the game has started
        music?.play()
        vibrate()
    }
    
    func loseGame() {
        // Compare score to high score
        let currentScore = timerLabel.text!
        let highScore = getHighScore()
        
        if (currentScore > highScore) {
            setHighScore(newHighScore: currentScore)
            prevBest.text = currentScore
        }
        
        // Reset music
        music?.stop()
        music?.currentTime = 0
        
        // Go to lose screen
        performSegue(withIdentifier: "loseSeg", sender: self)
        
        // Reset UI
        gameStarted = false
        player1Touch = false
        player2Touch = false
        button.backgroundColor = .white
        p2Button.backgroundColor = .white
        
        //Reset timer
        timer.invalidate()
        timerLabel.text = "00:00:00"
    }
    
    @objc func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var elapsedTime = currentTime - startTime
        
        // Calculate time in Hours:Minutes:Seconds
        let hours = Int(elapsedTime / 3600.0)
        elapsedTime -= TimeInterval(hours) * 3600
        let minutes = Int(elapsedTime / 60.0)
        elapsedTime -= TimeInterval(minutes) * 60
        let seconds = Int(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        // Formatting
        let strHours = String(format:"%02d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
    }
    
    @objc func player1Touched() {
        player1Touch = true
        
        button.backgroundColor = .gray
        
        if (player2Touch) {
            startGame()
        }
    }
    
    @objc func player1Released() {
        player1Touch = false
        
        button.backgroundColor = .white
        
        if gameStarted {
            loseGame()
        }
    }
    
    @objc func player2Touched() {
        player2Touch = true
        
        p2Button.backgroundColor = .gray
        
        if player1Touch {
            startGame()
        }
    }
    
    @objc func player2Released() {
        player2Touch = false
        
        p2Button.backgroundColor = .white
        
        if gameStarted {
            loseGame()
        }
    }
    
    func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func setupUI() {
        timerLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        // Making Player1 button with code
        let screen = UIScreen.main.bounds
        let verticalOffset: CGFloat = 50
        let width: CGFloat = 100
        let height: CGFloat = 100
        let xPos = screen.midX - (width / CGFloat(2))
        var yPos = screen.maxY - (height + verticalOffset)
        button.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(player1Touched), for: .touchDown)
        button.addTarget(self, action: #selector(player1Released), for: .touchUpInside)
        button.addTarget(self, action: #selector(player1Released), for: .touchDragExit)
        view.addSubview(button)
        
        // Label for Player1 button
        let labelHeight: CGFloat = 56
        yPos -= labelHeight
        let p1Label = UILabel(frame: CGRect(x: xPos, y: yPos, width: width, height: labelHeight))
        p1Label.text = "Player 1"
        p1Label.textColor = .white
        p1Label.textAlignment = .center
        view.addSubview(p1Label)
        
        // Making Player2 button with code
        yPos = screen.minY + (verticalOffset)
        p2Button.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        
        p2Button.layer.cornerRadius = 0.5 * button.bounds.size.width
        p2Button.clipsToBounds = true
        p2Button.backgroundColor = .white
        p2Button.addTarget(self, action: #selector(player2Touched), for: .touchDown)
        p2Button.addTarget(self, action: #selector(player2Released), for: .touchUpInside)
        p2Button.addTarget(self, action: #selector(player2Released), for: .touchDragExit)
        view.addSubview(p2Button)
        
        // Label for Player2 button
        yPos = p2Button.bounds.maxY + labelHeight
        let p2Label = UILabel(frame: CGRect(x: xPos, y: yPos, width: width, height: labelHeight))
        p2Label.text = "Player 2"
        p2Label.textColor = .white
        p2Label.textAlignment = .center
        p2Label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        view.addSubview(p2Label)
        
        // Previous best label
        prevBest.frame = CGRect(x: screen.midX + 50, y: screen.midY, width: 100, height: 25)
        prevBest.text = getHighScore()
        prevBest.textColor = .white
        prevBest.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        view.addSubview(prevBest)
        
        // Setup Music for playback
        let path = Bundle.main.path(forResource: "SuperHex.mp3", ofType:nil)!
        let musicURL = URL(fileURLWithPath: path)
        
        do {
            music = try AVAudioPlayer(contentsOf: musicURL)
        } catch {
            print("Error occured playing sound")
        }
    }
    
    /*
    // MARK: ACTIONS
    @IBAction func button(_ sender: UIButton) {
        print("player 1 touched")
        player1Touch = true
        
        if (player2Touch) {
            startGame()
        }
    }
    
    @IBAction func p1ReleasedOutside(_ sender: UIButton) {
        print("player 1 released")
        player1Touch = false
        
        if gameStarted {
            loseGame()
        }
    }
    
    @IBAction func release(_ sender: UIButton) {
        print("player 1 released")
        player1Touch = false
        
        if gameStarted {
            loseGame()
        }
        
    }
    
    @IBAction func p2Touched(_ sender: UIButton) {
        print("player 2 touched")
        player2Touch = true
        
        if player1Touch {
            startGame()
        }
    }
    
    @IBAction func p2Released(_ sender: UIButton) {
        print("player 2 released")
        player2Touch = false
        
        if gameStarted {
            loseGame()
        }
    }
    
    @IBAction func p2ReleasedOutside(_ sender: UIButton) {
        print("player 2 released")
        player2Touch = false
        
        if gameStarted {
            loseGame()
        }
    }
 */
    
}

