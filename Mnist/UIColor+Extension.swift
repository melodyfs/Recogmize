//
//  UIColor+Extension.swift
//  Mnist
//
//  Created by Melody on 4/14/18.
//  Copyright © 2018 Melody Yang. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    convenience init(red: Double, green: Double, blue: Double) {
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
    
    static var violetBlue = {
        return UIColor(red:0.37, green:0.44, blue:0.93)
    }()
    
    static var violetPurple = {
        return UIColor(red:0.64, green:0.38, blue:0.98)
    }()
    
    static var cherryPink = {
        return UIColor(red:1.00, green:0.09, blue:0.61)
    }()
    
}
