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

    private let timeLabel = UILabel()
    private let stepper = UIStepper()
    private let actionButton = UIButton()

    var startStopHagdler: (() -> Void)?


    @objc func stepperChanged() {
        updateUI()
    }

    @objc func actionButtonTapped() {
        startStopHagdler?()
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

        setNeedsLayout()
        
    }



    // добавление controlView в интерфейс -------------------------------------------------- //
    private let actionButtonTopMargin: CGFloat = 8
    private let timeToStepperMargin: CGFloat = 8

    // формируем размер поля
    override var intrinsicContentSize: CGSize {
        let stepperSize = stepper.intrinsicContentSize
        let timeLabelSize = timeLabel.intrinsicContentSize
        let buttonSize = actionButton.intrinsicContentSize
        
        let width = timeLabelSize.width + timeToStepperMargin + stepperSize.width
        let height = stepperSize.height + actionButtonTopMargin + buttonSize.height
        
        return CGSize(width: width, height: height)
    }
    
    // ставим все элементы на свои места
    override func layoutSubviews() {
        super.layoutSubviews()

        // прижимаем степпер к левому верхнему углу
        let stepperSize = stepper.intrinsicContentSize
        stepper.frame = CGRect(
            origin: CGPoint(
                x: bounds.maxX - stepperSize.width,
                y: bounds.minY
            ),
            size: stepperSize
        )

        // прижимаем степер к левой стороне и центрируем по горизонтали со степпером
        let timeLabelSize = timeLabel.intrinsicContentSize
        timeLabel.frame = CGRect(
            origin: CGPoint(
                x: bounds.minX,
                y: bounds.minY + (stepperSize.height - timeLabelSize.height) / 2
            ),
            size: timeLabelSize
        )

        // устанавливаем кнопку центрируя по вертикали и на расстоянии от треппера в 'acitonButtonTopMargin'
        let buttonSize = actionButton.intrinsicContentSize
        actionButton.frame = CGRect(
            origin: CGPoint(
                x: bounds.minX + (bounds.width - buttonSize.width)/2,
                y: stepper.frame.maxY + actionButtonTopMargin
            ),
            size: buttonSize
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }


    private func setupViews() {
        addSubview(timeLabel)
        addSubview(stepper)
        addSubview(actionButton)

        timeLabel.translatesAutoresizingMaskIntoConstraints = true
        stepper.translatesAutoresizingMaskIntoConstraints = true
        actionButton.translatesAutoresizingMaskIntoConstraints = true

        stepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        actionButton.setTitleColor(actionButton.tintColor, for: .normal)
        
        updateUI()
    }
    // ------------------------------------------------------------------------------------- //

}
