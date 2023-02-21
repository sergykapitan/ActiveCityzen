//
//  AnimationCircleView.swift
//  ActiveCitizen
//
//  Created by Sergey on 11.02.2021.
//  Copyright © 2021 Novotorica. All rights reserved.
//

import UIKit

class AnimationCircleView: UIView {
    
    var circleLayer: CAShapeLayer!
    var viewCenter: CGPoint!
    
    var isAnimationCompleted = true
   
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        //arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
       // guard let viewCenter = viewCenter else { return }
        //radius:
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0) ,radius: (frame.size.width + 10) / 2, startAngle: 0.0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)

        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5.0

        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0

        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    var animationCompletedCallback: ((_ isAnimationCompleted: Bool) -> Void)?

    func animateCircle(duration: TimeInterval,value: Float) {
        
        CATransaction.setCompletionBlock {
            if let callBack = self.animationCompletedCallback { callBack(self.isAnimationCompleted) }
            }
        
        
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        // Set the animation duration appropriately
        animation.duration = duration

        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        //1
        animation.toValue = value
        
        animation.repeatCount = .infinity

        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = CGFloat(value)

        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    func removeLayers() {
        circleLayer.removeAllAnimations()
        circleLayer.removeFromSuperlayer()
    }
}

