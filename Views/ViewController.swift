//
//  ViewController.swift
//  Views
//
//  Created by Артем Рылов on 18/07/2019.
//  Copyright © 2019 Артем Рылов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameControl: GameControlView!
    @IBOutlet weak var gameFieldView: GameFieldView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    func actionButtonTapped() {
        if gameControl.isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    
    
    
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    
    private var score = 0
    
    
    
    private func startGame() {
        
        // обнуляем счетчик
        score = 0
        
        // двигаем объект
        repositionImageWithTimer()
        
        // запускаем таймер игры
        //gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true
        )
        
        // забираем время у stepper время и UI
        gameControl.gameTimeLeft = gameControl.gameDuration
        gameControl.isGameActive = true
        updateUI()
        
    }
    
    @objc private func gameTimerTick() {
        gameControl.gameTimeLeft -= 1
        if gameControl.gameTimeLeft >= 0 {
            updateUI()
        } else {
            stopGame()
        }
    }
    
    func objectTapped() {
        guard gameControl.isGameActive else { return }
        
        repositionImageWithTimer()
        score += 1
    }
    
    
    private func repositionImageWithTimer() {
        
        timer?.invalidate() // обнуляем таймер
        timer = Timer.scheduledTimer(
            timeInterval: displayDuration,
            target: self,
            selector: #selector(moveImage),
            userInfo: nil,
            repeats: true
        )
        timer?.fire() // для срабатывания сразу, а не через пару секунд
        
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    
    
    private func stopGame() {
        gameControl.isGameActive = false
        
        updateUI()
        
        // обнуляем оба таймера
        gameTimer?.invalidate()
        timer?.invalidate()
        
        scoreLabel.text = "Последний счет: \(score)"
    }

    
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !gameControl.isGameActive
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настраиваем рамку вокруг игрового поля
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        
        
        updateUI()
        
        gameControl.startStopHandler = { [weak self] in
            self?.actionButtonTapped()
        }
        
        gameFieldView.shapeHitHandler = { [weak self] in
            self?.objectTapped()
        }
        
        gameControl.gameDuration = 20
        
    }


}

