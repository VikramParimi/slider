//
//  Slider.swift
//  VerticalGradientSlider
//
//  Created by Pairmi, Vikram (US - Bengaluru) on 8/29/18.
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

protocol SliderDelegate: class {
    func startShowingSliderText()
    func updateSliderText()
}

class Slider: UISlider {
    
    var sliderTextView: SliderTextView?
    weak var delegate: SliderDelegate?
    
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let customBounds = CGRect(x: -bounds.origin.x, y: bounds.height/2 - 10, width: bounds.size.width, height: 20)
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    func intializeSliderToolTipView() {
        if sliderTextView == nil {
            sliderTextView = SliderTextView(frame: .zero)
            sliderTextView?.sliderValue = String(self.value)
            sliderTextView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
            addSubview(self.sliderTextView!)
        }
    }
    
    func updateSliderToolTipPosition()  {
        let thumbRect = self.thumbRect()
        let toolTipRect = thumbRect.offsetBy(dx: 0, dy: bounds.size.height)
        sliderTextView?.frame.size.width  = 50
        sliderTextView?.frame.size.height = 100
        sliderTextView?.center.x = toolTipRect.midX
        sliderTextView?.center.y = toolTipRect.midY
        sliderTextView?.backgroundColor = UIColor.clear
        sliderTextView?.sliderValue = String(Int(self.value))
        //To re-draw slider text
        sliderTextView?.setNeedsDisplay()
    }
    
    func hideSliderToolTip() {
        sliderTextView?.removeFromSuperview()
    }
    
    func thumbRect() -> CGRect {
        return self.thumbRect(forBounds: self.bounds, trackRect: self.trackRect(forBounds: self.bounds), value: self.value)
    }
    
    @objc func sliderValueChanged(slider: UISlider, forEvent: UIEvent) {
        //Round the Slider Value
        if let touchEvent = forEvent.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                let touchLocation = touchEvent.location(in: self)
                if self.thumbRect().contains(touchLocation) {
                    intializeSliderToolTipView()
                    updateSliderToolTipPosition()
                }
            case .moved, .stationary, .ended:
                updateSliderToolTipPosition()
            default:
                break
            }
        }
    }
}
