//
//  VerticalSlider.swift
//  VerticalGradientSlider
//
//  Created by Pairmi, Vikram (US - Bengaluru) on 8/28/18.
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

@IBDesignable open class VerticalSlider: UIControl {
    
    public let slider = Slider()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    // required for IBDesignable class to properly render
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }

    fileprivate func initialize() {
        addSubview(slider)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        //Transform the slider to vertical
        slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
        
        //Adjust slider frame
        slider.bounds.size.width = bounds.height
        slider.center.x = bounds.midX
        slider.center.y = bounds.midY
        
        updateSlider()
    }
    
    func updateSlider() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
        
        let thumbImage = renderer.image { context in
            context.cgContext.setFillColor(UIColor.white.cgColor)
            context.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: 30, height: 30))
            context.cgContext.drawPath(using: .fillStroke)
            context.cgContext.closePath()
        }
        
        slider.setThumbImage(thumbImage, for: .normal)
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: slider.intrinsicContentSize.height, height: slider.intrinsicContentSize.width)
        }
    }
}

public class Slider: UISlider {
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(x: bounds.origin.x, y: bounds.height/2 - 10, width: bounds.size.width, height: 20)
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    public override func minimumTrackImage(for state: UIControl.State) -> UIImage? {
        return getTrackImageWith(color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
    }
    
    public override func maximumTrackImage(for state: UIControl.State) -> UIImage? {
        return getTrackImageWith(color: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1))
    }
    
//    public override func thumbImage(for state: UIControl.State) -> UIImage? {
//        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30))
//
//        let thumbImage = renderer.image { context in
//            context.cgContext.setFillColor(UIColor.white.cgColor)
//            context.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: 30, height: 30))
//            context.cgContext.drawPath(using: .fillStroke)
//            context.cgContext.closePath()
//        }
//        return thumbImage
//    }
    
    fileprivate func getTrackImageWith(color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        let image = renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            let rect = CGRect(x: 0, y: 0, width: bounds.width, height: 20)
            context.cgContext.fill(rect)
            context.cgContext.drawPath(using: .fillStroke)
            context.cgContext.closePath()
        }
        return image
    }
}
