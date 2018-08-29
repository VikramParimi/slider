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
    private lazy var sliderTextLabel = UILabel()

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
        
        slider.delegate = self
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
        
        //Update slider appearance with gradientlayers and new thumb image
        updateSliderApperance()
        
        //Adjust gradientView frame
        gradientView.center.x = bounds.midX
        gradientView.center.y = bounds.midY
        
        gradientView.bounds.size.width  = slider.trackRect(forBounds: slider.bounds).height
        gradientView.bounds.size.height = slider.trackRect(forBounds: slider.bounds).width
        
        gradientView.layer.cornerRadius = 10
    }
    
    fileprivate func updateSliderApperance() {
        
        //Set the custom thumb image
        let thumbImage = getImagefor(SliderImageType.thumb,
                                     ofSize: CGSize(width: 27.5, height: 27.5),
                                     withColor: UIColor.white)
        
        //Set an Empty Image
        let minimumTrackImage = getImagefor(SliderImageType.minimumTrack,
                                            ofSize: CGSize(width: 20, height: 20),
                                            withColor: UIColor.clear)
        
        //Set the maximum track image with one single color and resize it along
        var maximumTrackImage = getImagefor(SliderImageType.maximumTrack,
                                            ofSize: CGSize(width: 20, height: 20),
                                            withColor: #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1))
        maximumTrackImage = maximumTrackImage.resizableImage(withCapInsets: UIEdgeInsets(top: 8,
                                                                                         left: 8,
                                                                                         bottom: 8,
                                                                                         right: 8),
                                                             resizingMode: .stretch)
        
        slider.setMinimumTrackImage(minimumTrackImage, for: .normal)
        slider.setThumbImage(thumbImage, for: .normal)
        slider.setMaximumTrackImage(maximumTrackImage, for: .normal)
        
        //Set the selector for tracking the value changes of the slider
        slider.addTarget(slider, action: #selector(Slider.sliderValueChanged(slider:forEvent:)), for: .valueChanged)
        
        // FIXME: Removed hardcoded values, set through IB Inspectables
        slider.minimumValue = 0
        slider.value = 10
        slider.maximumValue = 100
    }
    
    fileprivate func getImagefor(_ type: SliderImageType, ofSize: CGSize, withColor: UIColor) -> UIImage {

        let renderer = UIGraphicsImageRenderer(size: ofSize)
        let image = renderer.image { context in
            context.cgContext.setFillColor(withColor.cgColor)
            
            let rect  = CGRect(x: 0,
                               y: 0,
                               width: ofSize.width,
                               height: ofSize.height)
            context.cgContext.fillEllipse(in: rect)
            context.cgContext.drawPath(using: .fillStroke)
            context.cgContext.closePath()
            
            switch type {
            case .thumb:
//                context.cgContext.setStrokeColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))
//                context.cgContext.setLineWidth(0.3)
//                context.cgContext.strokeEllipse(in: rect)
                let innerShadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                let innerShadowOffet = CGSize(width: ofSize.width, height: ofSize.height)
                context.cgContext.setShadow(offset: innerShadowOffet,
                                            blur: 1,
                                            color: innerShadowColor.cgColor)
                context.cgContext.fillPath()
                break
            case .minimumTrack:
                break
            case .maximumTrack:
                let innerShadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                let innerShadowOffet = CGSize(width: ofSize.width, height: ofSize.height)
                context.cgContext.setShadow(offset: innerShadowOffet,
                                            blur: 3,
                                            color: innerShadowColor.cgColor)
                context.cgContext.fillPath()
            }
        }
        return image
    }
}

extension VerticalSlider {
    
}

extension VerticalSlider: SliderDelegate {
    
    func startShowingSliderText() {
        let sliderTextRect = slider.thumbRect()
        sliderTextLabel.center.x = sliderTextRect.midX
        sliderTextLabel.center.y = sliderTextRect.midY
        sliderTextLabel.frame.size = CGSize(width: 100, height: 50)
        addSubview(sliderTextLabel)
        sliderTextLabel.attributedText = attributed(String(slider.value))
    }
    
    func updateSliderText() {
        sliderTextLabel.attributedText = attributed(String(slider.value))
    }
    
    func attributed(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
            [.font : UIFont.systemFont(ofSize: 36, weight: .medium),
             .foregroundColor : #colorLiteral(red: 0.4549019608, green: 0.462745098, blue: 0.5058823529, alpha: 1)]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
}
