//
//  UIViewExtensions.swift
//  QuickNet
//
//  Created by DTran on 12/25/19.
//  Copyright © 2019 TPT. All rights reserved.
//

import UIKit

extension UIView {
    
    func setShadow(radius: CGFloat = 1, color: UIColor, offset: CGSize, opacity: Float = 0.5) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
    
    func addSubviews(_ view: [UIView]) {
        for index in 0..<view.count {
            self.addSubview(view[index])
        }
    }
    
    func setGradient(with colors: [CGColor], stopPoints: [NSNumber], startPoint: CGPoint = CGPoint(x: 0.5, y: 1.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 0.0)) {
        let gradient = CAGradientLayer()
        gradient.colors = colors
        gradient.cornerRadius = layer.cornerRadius
        gradient.endPoint = endPoint
        gradient.frame = bounds
        gradient.locations = stopPoints
        gradient.startPoint = startPoint
        layer.insertSublayer(gradient, at: 0)
    }
    
}
