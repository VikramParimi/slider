//
//  GradientView.swift
//  VerticalGradientSlider
//
//  Created by Pairmi, Vikram (US - Bengaluru) on 8/29/18.
//  Copyright © 2018 vikram. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override func layoutSubviews() {
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = bounds
        gradientlayer.cornerRadius = bounds.width/2
        gradientlayer.colors = [#colorLiteral(red: 0.7764705882, green: 0.9725490196, blue: 0, alpha: 0.5).cgColor, #colorLiteral(red: 0.09019607843, green: 0.2823529412, blue: 0.7098039216, alpha: 1).cgColor]
        gradientlayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientlayer)
    }
}
