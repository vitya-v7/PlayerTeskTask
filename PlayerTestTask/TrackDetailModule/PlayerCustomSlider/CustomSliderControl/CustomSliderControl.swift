//
//  CustomSliderControl.swift
//  PlayerTestTask
//
//  Created by Admin on 09.12.2022.
//

import Foundation
import UIKit

protocol CustomSliderControlDelegate: class {
    func customSliderControl(_ customSliderControl: CustomSliderControl,
                             onSliderValueChanged progress: Float)
    func customSliderControl(_ customSliderControl: CustomSliderControl,
                             rewindPlayerOnSliderValue progress: Float)
    func customSliderControlBeganChange(_ customSliderControl: CustomSliderControl)
}

class CustomSliderControl: UIControl {
    
    private let sliderMinimumValue: Float = 0.0
    private let sliderMaximumValue: Float = 1.0
    weak var delegate: CustomSliderControlDelegate?
    
    var progress: Float = 0 {
        willSet {
        } didSet {
            progress = progress > sliderMaximumValue ? sliderMaximumValue : progress
            progress = progress < sliderMinimumValue ? sliderMinimumValue : progress
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let height = rect.height
        let width = rect.width
        let pastColor: UIColor = .lightGray
        let fullColor: UIColor = .green
        
        let beforeRect = CGRect(x: 0,
                                y: height * 0.25,
                                width: width * CGFloat(progress),
                                height: 0.5 * height)
        let fullRect = CGRect(x: 0,
                              y: height * 0.25,
                              width: width,
                              height: 0.5 * height)
        let fullBezierPath: UIBezierPath = UIBezierPath(
            roundedRect: fullRect,
            cornerRadius: self.bounds.width * 0.5)
        
        let shapeLayerMask = CAShapeLayer()
        shapeLayerMask.path = fullBezierPath.cgPath
        shapeLayerMask.cornerRadius = self.bounds.width * 0.5
        shapeLayerMask.fillColor = UIColor.white.cgColor
        self.layer.mask = shapeLayerMask
        
        fullColor.set()
        fullBezierPath.fill()
        
        let beforeBezierPath: UIBezierPath = UIBezierPath(
            roundedRect: beforeRect,
            cornerRadius: self.bounds.width * 0.5)
        pastColor.set()
        beforeBezierPath.fill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.customSliderControlBeganChange(self)
        self.notifyDelegate(withTouches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.notifyDelegate(withTouches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.notifyDelegate(withTouches: touches)
        self.delegate?.customSliderControl(self,
                                           rewindPlayerOnSliderValue: self.progress)
    }
    
    private func notifyDelegate(withTouches touches: Set<UITouch>) {
        guard let touch = touches.first, self.bounds.width > 0 else {
            return
        }
        let touchPoint = touch.location(in: self)
        self.progress = Float(touchPoint.x / self.bounds.width)
        self.delegate?.customSliderControl(self,
                                           onSliderValueChanged: self.progress)
    }
    
}
