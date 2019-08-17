//
//  ViewController.swift
//  Views
//
//  Created by Артем Рылов on 18/07/2019.
//  Copyright © 2019 Артем Рылов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var gameFieldView: UIView!
    @IBOutlet weak var gameObject: UIImageView!
    @IBOutlet weak var shapeX: NSLayoutConstraint!
    @IBOutlet weak var shapeY: NSLayoutConstraint!
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        // выполняет только эту строку
        // timeLabel.text = "Время: \(Int(sender.value)) сек"
        updateUI()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }

    @IBAction func objectTapped(_ sender: UITapGestureRecognizer) {
        guard isGameActive else { return }
        
        repositionImageWithTimer()
        score += 1
    }
    
    
    private var isGameActive = false
    private var gameTimeLeft: TimeInterval = 0
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
        gameTimeLeft = stepper.value
        isGameActive = true
        updateUI()
        
    }
    
    private func stopGame() {
        isGameActive = false
        
        updateUI()
        
        // обнуляем оба таймера
        gameTimer?.invalidate()
        timer?.invalidate()
        
        scoreLabel.text = "Последний счет: \(score)"
    }
    
    
    private func updateUI() {
        
        gameObject.isHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        
        if isGameActive {
            timeLabel.text = "Осталось: \(Int(gameTimeLeft)) сек"
            actionButton.setTitle("Остановить", for: .normal)
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек"
            actionButton.setTitle("Начать", for: .normal)
        }
        
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
    
    
    @objc private func gameTimerTick() {
        gameTimeLeft -= 1
        if gameTimeLeft >= 0 {
            updateUI()
        } else {
            stopGame()
        }
    }
    
    @objc private func moveImage() {
        let maxX = gameFieldView.bounds.maxX - gameObject.frame.width
        let maxY = gameFieldView.bounds.maxY - gameObject.frame.height
        
        shapeX.constant = CGFloat(arc4random_uniform(UInt32(maxX)))
        shapeY.constant = CGFloat(arc4random_uniform(UInt32(maxY)))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настраиваем рамку вокруг игрового поля
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        
        updateUI()
        
    }


}
