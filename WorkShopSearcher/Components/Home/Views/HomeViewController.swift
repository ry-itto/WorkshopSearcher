//
//  HomeViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import XLPagerTabStrip

/// ホーム画面
final class HomeViewController: ButtonBarPagerTabStripViewController {

    static func instantiateWithTabbarItem() -> UINavigationController {
        let hvc = HomeViewController()
        hvc.title = "ホーム"
        let navigationController = UINavigationController(rootViewController: hvc)
        navigationController.title = "ホーム"
        navigationController.tabBarItem.image = UIImage(named: "home")
        navigationController.navigationBar.barTintColor = UIColor.Base.main.color()
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Base.sub.color()]
        navigationController.navigationBar.tintColor = .white

        return navigationController
    }

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.selectedBarBackgroundColor = UIColor.Base.select.color()
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,
            progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .darkGray
        }
        buttonBarView.layer.borderWidth = 0.5
        buttonBarView.layer.borderColor = UIColor.lightGray.cgColor
        super.viewDidLoad()
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [ConnpassEventViewController(), SupporterzColabEventViewController()]
    }
}
