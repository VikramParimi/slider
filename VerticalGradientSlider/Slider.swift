//
//  Slider.swift
//  VerticalGradientSlider
//
//  Created by Pairmi, Vikram (US - Bengaluru) on 8/29/18.
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

internal protocol SliderDelegate: class {
    func sliderMovementBegan()
    func sliderMoved()
}

private enum SliderConstants {
    static let trackHeight: CGFloat = 20
}

public class Slider: UISlider {
    
    internal weak var delegate: SliderDelegate?
    
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let customBounds = CGRect(x: bounds.origin.x,
                                  y: (bounds.height/2 - SliderConstants.trackHeight/2),
                                  width: bounds.size.width,
                                  height: SliderConstants.trackHeight)
        
        super.trackRect(forBounds: customBounds)
        
        return customBounds
    }
    
    internal func thumbRect() -> CGRect {
        return self.thumbRect(forBounds: self.bounds,
                              trackRect: self.trackRect(forBounds: self.bounds),
                              value: self.value)
    }
    
    @objc internal func sliderValueChanged(slider: UISlider, forEvent: UIEvent) {
        if let touchEvent = forEvent.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                let touchLocation = touchEvent.location(in: self)
                if self.thumbRect().contains(touchLocation) {
                    delegate?.sliderMovementBegan()
                }
            case .moved, .stationary, .ended:
                delegate?.sliderMoved()
            default:
                break
            }
        }
    }
}
