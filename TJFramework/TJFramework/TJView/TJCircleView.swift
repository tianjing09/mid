//
//  TJCircleView.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/22.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

 class TJCircleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var circleLayers = [CAShapeLayer]()
    var circleData = [String]()
    var colors = [UIColor]()
    var width: CGFloat = 0
    var height: CGFloat = 0
    var total:Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        width = frame.size.width
        height = frame.size.height
//        let view = UIView.init(frame: CGRect(x: 10, y: 10, width: width - 20, height: height - 20))
//        view.layer.cornerRadius = (width - 20) / 2
//        view.layer.borderColor = UIColor.yellow.cgColor
//        view.layer.borderWidth = 40
//        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshView(data:[String]) {
       self.circleData = data
       self.total = totalValue()
       self.drawCircle()
        for layer in self.circleLayers {
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = 1.0
            pathAnimation.repeatCount = 1
            pathAnimation.isRemovedOnCompletion = true
            pathAnimation.fromValue = 0
            pathAnimation.toValue = 1.0
            layer.add(pathAnimation, forKey: "strokeEnd")
        }
    }
    
    func totalValue() -> Float {
        var t: Float = 0
        for data in self.circleData {
            t = t + (Float(data) ?? 0)
        }
        return t
    }
   
    func drawCircle() {
        for layer in self.circleLayers {
            layer.removeFromSuperlayer()
        }
        
        var start:Float = 0
        for (index, data) in self.circleData.enumerated() {
            let value = (Float(data) ?? 0) / self.total * 2 * Float(Double.pi)
            let end = value + start
            let path = UIBezierPath(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: (width - 60) / 2, startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: true)
            start = end
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = self.colors[index].cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = 40
            self.layer.addSublayer(layer)
            self.circleLayers.append(layer)
        }
    }
    
    
}
