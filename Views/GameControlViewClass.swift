//
//  GameControlViewClass.swift
//  Views
//
//  Created by Артем Рылов on 21/07/2019.
//  Copyright © 2019 Артем Рылов. All rights reserved.
//

import UIKit


@IBDesignable
class GameControlView: UIView {
    
    @IBInspectable var isGameActive: Bool = false {
        didSet { updateUI() }
    }
    @IBInspectable var gameTimeLeft: Double = 7 {
        didSet { updateUI() }
    }
    @IBInspectable var gameDuration: Double {
        get { return stepper.value }
        set {
            stepper.value = newValue
            updateUI()
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var actionButton: UIButton!
    
    var startStopHandler: (() -> Void)?
    
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        startStopHandler?()
    }
    
    
    
    private func updateUI() {
        
        stepper.isEnabled = !isGameActive
        
        if isGameActive {
            timeLabel.text = "Осталось: \(Int(gameTimeLeft)) сек"
            actionButton.setTitle("Остановить", for: .normal)
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек"
            actionButton.setTitle("Начать", for: .normal)
        }
        
    }
    
    
    
    // добавление controlView в интерфейс -------------------------------------------------- //
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "GameControlView", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    // ------------------------------------------------------------------------------------- //
    
}
