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

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .lightGray
        settings.style.buttonBarItemBackgroundColor = .lightGray
        settings.style.buttonBarItemTitleColor = .black
        
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [ConnpassEventViewController(), SupporterzColabEventViewController()]
    }
}
