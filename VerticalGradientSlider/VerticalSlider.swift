//
//  VerticalSlider.swift
//  VerticalGradientSlider
//
//  Created by Pairmi, Vikram (US - Bengaluru) on 8/28/18.
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

private enum SliderImageType {
    case thumb
    case minimumTrack
    case maximumTrack
}

@IBDesignable public class VerticalSlider: UIControl {
    
    private let slider = Slider()
    private let gradientView = GradientView()

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
        addSubview(gradientView)
        addSubview(slider)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        //Transform the slider to vertical
        slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
        
        //Adjust slider frame
        slider.bounds.size.width = bounds.height - 10
        slider.center.x = bounds.midX
        slider.center.y = bounds.midY
        
        updateSliderApperance()
        
        //Adjust gradientView frame
        gradientView.center.x = bounds.midX
        gradientView.center.y = bounds.midY
        
        gradientView.bounds.size.width  = slider.trackRect(forBounds: slider.bounds).height
        gradientView.bounds.size.height = slider.trackRect(forBounds: slider.bounds).width
        
        gradientView.layer.cornerRadius = 10
    }
    
    fileprivate func updateSliderApperance() {
        
        let thumbImage = getImagefor(SliderImageType.thumb,
                                     ofSize: CGSize(width: 27.5, height: 27.5),
                                     withColor: UIColor.white)
        slider.setThumbImage(thumbImage, for: .normal)
        
        let minimumTrackImage = getImagefor(SliderImageType.minimumTrack,
                                            ofSize: CGSize(width: 20, height: 20),
                                            withColor: UIColor.clear)
        slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        
        var maximumTrackImage = getImagefor(SliderImageType.maximumTrack,
                                            ofSize: CGSize(width: 20, height: 20),
                                            withColor: UIColor.lightGray)
        maximumTrackImage = maximumTrackImage.resizableImage(withCapInsets: UIEdgeInsets(top: 8,
                                                                                         left: 8,
                                                                                         bottom: 8,
                                                                                         right: 8),
                                                             resizingMode: .stretch)
        slider.setMaximumTrackImage(maximumTrackImage, for: .normal)
        
        slider.minimumValue = 0
        slider.value = 4
        slider.maximumValue = 10
    }
    
    fileprivate func getImagefor(_ type: SliderImageType, ofSize: CGSize, withColor: UIColor) -> UIImage {

        let renderer = UIGraphicsImageRenderer(size: ofSize)
        
        let image = renderer.image { context in
            context.cgContext.setFillColor(withColor.cgColor)
            context.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: ofSize.width, height: ofSize.height))
            
            switch type {
            case .thumb:
                break
            case .minimumTrack:
                break
            case .maximumTrack:
                break
            }
            
            context.cgContext.drawPath(using: .fillStroke)
            context.cgContext.closePath()
        }
        return image
    }
}


private class Slider: UISlider {
    
    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        let customBounds = CGRect(x: bounds.origin.x, y: bounds.height/2 - 10, width: bounds.size.width, height: 20)
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}

private class GradientView: UIView {
    
    override func layoutSubviews() {
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = bounds
        gradientlayer.cornerRadius = 10
        gradientlayer.colors = [#colorLiteral(red: 0.7764705882, green: 0.9725490196, blue: 0, alpha: 0.5).cgColor, #colorLiteral(red: 0.09019607843, green: 0.2823529412, blue: 0.7098039216, alpha: 1).cgColor]
        gradientlayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientlayer)
    }
}
