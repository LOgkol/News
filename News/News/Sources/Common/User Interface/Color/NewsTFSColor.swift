//
//  NewsTFSColor.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

import UIKit

enum NewsTFSColor {
    
    static var titaniumGrey: UIColor {
        return rgbColor(red: 83, green: 91, blue: 99, alpha: 1)
    }
    
    static var oceanBoatBlue: UIColor {
        return rgbColor(red: 1, green: 115, blue: 193, alpha: 1)
    }
    
    static var osloGrey: UIColor {
        return rgbColor(red: 134, green: 140, blue: 145, alpha: 1)
    }
    
    private static func rgbColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return .init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
}

