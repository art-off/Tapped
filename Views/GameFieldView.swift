//
//  GameFieldView.swift
//  Views
//
//  Created by Артем Рылов on 19/07/2019.
//  Copyright © 2019 Артем Рылов. All rights reserved.
//

import UIKit


@IBDesignable
class GameFieldView: UIView {
    
    // поля для настраивания свойств треугольника и его позиции
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40)
    @IBInspectable var shapeColor: UIColor = .red
    @IBInspectable var shapePosition: CGPoint = .zero {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var isShapeHidden: Bool = false {
        didSet { setNeedsDisplay() }
    }
    
    // замыкание, которое вызывается при нажатии на треугольник
    // инициализируется в viewDidLoad()
    var shapeHitHandler: (() -> Void)?
    
    
    
    // переменная, запоминающия послдений нарисованный треугольник
    private var curPath: UIBezierPath?
    
    // функция, рисующая треугольник
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isShapeHidden else {
            curPath = nil
            return
        }
        
        // устанавливаем цвет, фигуру и заливаем
        shapeColor.setFill()
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        path.fill()
        
        curPath = path
    }
    
    // построение треугольника
    private func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        path.lineWidth = 0
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        
        path.stroke()
        path.fill()
        
        return path
        
    }
    
    
    
    // обработка нажатий
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let curPath = curPath else { return }
        
        let hit = touches.contains(where: { touch -> Bool in
            let touchPoint = touch.location(in: self)
            return curPath.contains(touchPoint)
        })
        if hit {
            shapeHitHandler?()
        }
    }

    
    
    // передвижение треугольника в рандомные координаты
    func randomizeShapes() {
        let maxX = bounds.maxX - shapeSize.width
        let maxY = bounds.maxY - shapeSize.height
        let x = CGFloat(arc4random_uniform(UInt32(maxX)))
        let y = CGFloat(arc4random_uniform(UInt32(maxY)))
        
        shapePosition = CGPoint(x: x, y: y)
    }
    
    
}
