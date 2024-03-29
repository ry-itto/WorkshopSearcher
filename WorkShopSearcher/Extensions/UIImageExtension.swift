//
//  UIImageExtension.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/19.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(size change: CGSize) -> UIImage? {
        let widthRatio = change.width / size.width
        let heightRatio = change.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
