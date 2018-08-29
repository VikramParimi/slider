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
    
    weak var delegate: SliderDelegate?
    
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let customBounds = CGRect(x: -bounds.origin.x, y: bounds.height/2 - 10, width: bounds.size.width, height: 20)
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    func thumbRect() -> CGRect {
        return self.thumbRect(forBounds: self.bounds, trackRect: self.trackRect(forBounds: self.bounds), value: self.value)
    }
    
    @objc func sliderValueChanged(slider: UISlider, forEvent: UIEvent) {
        if let touchEvent = forEvent.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                let touchLocation = touchEvent.location(in: self)
                if self.thumbRect().contains(touchLocation) {
                    delegate?.startShowingSliderText()
                    delegate?.updateSliderText()
                }
            case .moved, .stationary, .ended:
                delegate?.updateSliderText()
            default:
                break
            }
        }
    }
}
