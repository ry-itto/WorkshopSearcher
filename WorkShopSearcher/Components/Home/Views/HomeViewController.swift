//
//  HomeViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import XLPagerTabStrip

final class HomeViewController: ButtonBarPagerTabStripViewController {
    
    static func instantiateWithTabbarItem() -> UINavigationController {
        let hvc = HomeViewController()
        hvc.title = "ホーム"
        let nc = UINavigationController(rootViewController: hvc)
        nc.title = "ホーム"
        nc.tabBarItem.image = UIImage(named: "home")
        return nc
    }

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.selectedBarBackgroundColor = .orange
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .darkGray
            newCell?.label.textColor = .orange
        }
        buttonBarView.layer.borderWidth = 0.5
        buttonBarView.layer.borderColor = UIColor.lightGray.cgColor
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [ConnpassEventViewController(), SupporterzColabEventViewController()]
    }
}
