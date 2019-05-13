//
//  SearchViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    static func instantiateWithTabbarItem() -> UINavigationController {
        let svc = SearchViewController()
        svc.title = "検索"
        let nc = UINavigationController(rootViewController: svc)
        nc.title = "検索"
        nc.tabBarItem.image = UIImage(named: "search")
        return nc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
