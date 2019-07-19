//
//  SettingViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/19.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

final class SettingViewController: UIViewController {
    
    static func instantiateWithTabbarItem() -> UINavigationController {
        let svc = SettingViewController()
        svc.title = "設定"
        let nc = UINavigationController(rootViewController: svc)
        nc.title = "設定"
        nc.tabBarItem.image = UIImage(named: "setting")
        return nc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
