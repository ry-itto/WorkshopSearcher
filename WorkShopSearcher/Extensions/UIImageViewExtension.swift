//
//  UIImageViewExtension.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/08/23.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(from url: URL?) {
        DispatchQueue.global().async { [weak self] in
            guard
                let url = url,
                let data = try? Data(contentsOf: url),
                let self = self else { return }

            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
    }
}
