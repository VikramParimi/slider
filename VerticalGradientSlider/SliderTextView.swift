//
//  SliderTextView.swift
//  VerticalGradientSlider
//
//  Created by Pairmi, Vikram (US - Bengaluru) on 8/29/18.
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

class SliderTextView: UIView {
    
    var sliderValue = "0"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        
        let attributes: [NSAttributedString.Key: Any] =
            [.font : UIFont.systemFont(ofSize: 36, weight: .medium),
             .foregroundColor : #colorLiteral(red: 0.4549019608, green: 0.462745098, blue: 0.5058823529, alpha: 1)]
        let attributedString = NSAttributedString(string: sliderValue, attributes: attributes)
        let stringRect = CGRect(x: 30, y: bounds.midY - bounds.height/2 , width: bounds.size.width, height: bounds.size.height)
        attributedString.draw(in: stringRect)
    }
}
