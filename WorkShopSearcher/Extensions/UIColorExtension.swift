//
//  UIColorExtension.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/08/04.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(rgb: Int) {
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >>  8) / 255.0
        let blue = CGFloat( rgb & 0x0000FF       ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    convenience init(rgba: Int) {
        let red: CGFloat = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green: CGFloat = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue: CGFloat = CGFloat((rgba & 0x0000FF00) >>  8) / 255.0
        let alpha: CGFloat = CGFloat( rgba & 0x000000FF       ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    enum Base {
        case main
        case select
        case sub

        func color() -> UIColor {
            switch self {
            case .main:
                return UIColor(rgb: 0x17679E)
            case .select:
                return UIColor(rgb: 0x80CBF0)
            case .sub:
                return UIColor(rgb: 0xF4EFE7)
            }
        }
    }

    /// NipponColors.com の色格納列挙型
    /// http://nipponcolors.com/
    ///
    /// - sakura: 桜
    enum Nippon {
        case sakura

        func color() -> UIColor {
            switch self {
            case .sakura:
                return UIColor(rgb: 0xFEDFE1)
            }
        }
    }
}
