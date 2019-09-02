//
//  UIViewControllerExtension.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/28.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import SwiftMessages
import UIKit

extension UIViewController {
    func showConnectionAlert() {
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(body: "通信エラーです。通信環境の良いところで再度お試しください。")
        error.button?.setTitle("閉じる", for: .normal)
        SwiftMessages.show(view: error)
    }
}
