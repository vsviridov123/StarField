//
//  StarField.swift
//  Starfield
//
//  Created by Влад Свиридов on 08/11/2019.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import UIKit

struct SpeedHelper {
    // point / sec
    static var speed: CGFloat = 120
    static func getTime(distance: CGFloat) -> CGFloat {
        return distance / Self.speed
    }
}

final class Star: CAShapeLayer {
    
    private var endPoint: CGPoint!
    
    // MARK: Init
    override init(layer: Any) {
        super.init(layer: layer)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.setup()
    }
    
    static func initStarWithRandomPosition(sizeStar: CGSize, parentSize: CGSize, randomAlpha: Bool = false) -> Star {
        let randomPosition = CGPoint(x: CGFloat.random(in: 0...parentSize.width), y: CGFloat.random(in: 0...parentSize.height))
        let result = Star(frame: CGRect(origin: randomPosition, size: sizeStar))
        if randomAlpha {
            let color = UIColor.white.cgColor.copy(alpha: CGFloat.random(in: 0...100) / 100)
            result.fillColor = color
        }
        return result
    }
    
    // MARK: Interface
    func startAnimation() {
        self.endPoint = self.getEndPosition()
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        animation.fromValue = self.position
        animation.toValue = self.endPoint
        animation.duration = self.getDuration()
        animation.delegate = self
        self.add(animation, forKey: "star_position_animation")
    }
    
    // MARK: Private
    private func setup() {
        let bezierPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.width / 2)
        self.path = bezierPath.cgPath
        self.fillColor = UIColor.white.cgColor
        self.backgroundColor = UIColor.clear.cgColor
        self.drawsAsynchronously = true
    }
    
    func getEndPosition() -> CGPoint {
        guard let superLayer = self.superlayer else { return .zero}
        return CGRect.getNewFrameAndPointWherePointNoSee(point: self.position, oldFrame: superLayer.frame, parentSize: superLayer.bounds.size).newPoint
    }
    
    func getDuration() -> CFTimeInterval {
        return Double(SpeedHelper.getTime(distance: self.position.absoluteDistance(to: self.endPoint)))
    }
}

extension Star: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.startAnimation()
        }
    }
}

class StarFieldView: UIView {
    private var starCount = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startAnimation() {
        for _ in 0..<self.starCount {
            let star = Star.initStarWithRandomPosition(sizeStar: CGSize(width: 8, height: 8), parentSize: self.bounds.size)
            star.startAnimation()
            self.layer.addSublayer(star)
        }
    }
}
