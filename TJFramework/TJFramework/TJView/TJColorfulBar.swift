//
//  TJColorfulBar.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/20.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

class TJColorfulBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var maxValue = 10.0
    var minValue = 1.0
    var colors:[UIColor] = []
    var barData: [[String]] = []
    var isPercent = false
    var showType = 2
    
    private var perBar = 20.0
    private var perGrid = 40.0
    private var width = 1.0
    private var height = 1.0
    private var points: [[CGPoint]] = []
    private var barLayers: [CAShapeLayer] = []
    private var tipLabels: [UILabel] = []
    
    override  init(frame: CGRect) {
       super.init(frame: frame)
        width = Double(frame.size.width)
        height = Double(frame.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            super.frame = newFrame
            width = Double(newFrame.size.width)
            height = Double(newFrame.size.height)
        }
    }
    
    func  refreshView() {
        self.points.removeAll()
        perGrid = width / Double(self.barData.count)
        perBar = perGrid / 2
        for (index, bars) in self.barData.enumerated() {
            let x = perGrid * Double(index) + perGrid / 2
            var perPoints:[CGPoint] = []
            var oy = 0.0
            for bar in bars {
                let h = (Double(bar) ?? 0) / maxValue * height
                let totalH = oy + h
                let y = height - totalH
                oy = totalH
                perPoints.append(CGPoint(x: x, y: y))
            }
            self.points.append(perPoints)
        }
        drawBar()
        for layer in self.barLayers {
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 1.0
            pathAnimation.repeatCount = 1
            pathAnimation.isRemovedOnCompletion = true
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1.0
            layer.add(pathAnimation, forKey: "strokeEnd")
        }
    }
    
    private func drawBar() {
        for layer in self.barLayers {
            layer.removeFromSuperlayer()
        }
        
        for subview in self.subviews {
            subview.isHidden = true
        }
        
        for (i,perPoints) in self.points.enumerated() {
            var reh = CGFloat(height)
            for (index, point) in perPoints.enumerated() {
                let path = UIBezierPath()
                let endPoint = point
                let startPoint = CGPoint(x:point.x,y:reh)
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                reh = endPoint.y
                
                
                let layer = CAShapeLayer()
                layer.path = path.cgPath
                let color = self.colors[index]
                layer.strokeColor = color.cgColor
                layer.lineWidth = CGFloat(self.perBar)
                self.layer.addSublayer(layer)
                self.barLayers.append(layer)
                
                if showType == 2 {
                    var label = self.viewWithTag(1111 + i * perPoints.count + index) as? UILabel
                    if label == nil {
                        label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 50, height: 12))
                        label?.font = UIFont.systemFont(ofSize: 10)
                        label?.textColor = .gray
                        label?.tag = 1111 + i * perPoints.count + index
                        label?.textAlignment = .center
                        self.addSubview(label!)
                    }
                    label?.center = CGPoint(x: endPoint.x, y: (endPoint.y + startPoint.y) / 2)
                    self.bringSubviewToFront(label!)
                    if Float(self.barData[i][index]) == 0 {
                        label?.isHidden = true
                    } else {
                        label?.isHidden = false
                        label?.text = self.barData[i][index]
                    }
                }
            }
        }
    }
}
