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

public protocol VerticalSliderDelegate: class {
    func sliderMovementBegan()
    func sliderMoved()
}

@IBDesignable public class VerticalSlider: UIControl {
    
    private let slider = Slider()
    private let gradientView = GradientView()
    private lazy var sliderTextLabel = UILabel()
    
    public weak var delegate: VerticalSliderDelegate?

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
        
        //Update slider appearance with gradientlayers and new thumb image
        updateSliderApperance()
        
        //Adjust gradientView frame
        updateGradientViewApperance()
    }
    
    fileprivate func updateSliderApperance() {
        
        //Transform the slider to vertical
        slider.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.5)
        
        //Adjust slider frame
        slider.bounds.size.width = bounds.height - 10
        slider.center.x = bounds.midX
        slider.center.y = bounds.midY
        
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
    }
    
    fileprivate func updateGradientViewApperance() {
        
        gradientView.center.x = bounds.midX
        gradientView.center.y = bounds.midY
        
        gradientView.bounds.size.width  = slider.trackRect(forBounds: slider.bounds).height
        gradientView.bounds.size.height = slider.trackRect(forBounds: slider.bounds).width
        
        gradientView.layer.cornerRadius = 10
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
        }
        return image
    }
}

// MARK:- IBInspeactables
extension VerticalSlider {
    
    @IBInspectable open var minimumValue: Float {
        get {
            return slider.minimumValue
        }
        set {
            slider.minimumValue = newValue
        }
    }
    
    @IBInspectable open var maximumValue: Float {
        get {
            return slider.maximumValue
        }
        set {
            slider.maximumValue = newValue
        }
    }
    
    @IBInspectable open var value: Float {
        get {
            return slider.value
        }
        set {
            slider.setValue(newValue, animated: true)
        }
    }
}


extension VerticalSlider: SliderDelegate {
    
    func startShowingSliderText() {
        addSubview(sliderTextLabel)
        delegate?.sliderMovementBegan()
    }
    
    func updateSliderText() {
        let sliderThumbRect      = slider.thumbRect()
        sliderTextLabel.attributedText = attributed(String(lroundf(slider.value)))
        sliderTextLabel.sizeToFit()
        
        sliderTextLabel.frame.origin = CGPoint(x: slider.frame.origin.x + slider.bounds.height + 10, y: (slider.bounds.width - sliderThumbRect.midX - sliderTextLabel.bounds.height / 2) + 5)
        delegate?.sliderMoved()
    }
    
    fileprivate func attributed(_ text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
            [.font : UIFont.systemFont(ofSize: 36, weight: .medium),
             .foregroundColor : #colorLiteral(red: 0.4549019608, green: 0.462745098, blue: 0.5058823529, alpha: 1)]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        return attributedString
    }
}
