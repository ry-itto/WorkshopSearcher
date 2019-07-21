//
//  SettingViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/19.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: UITableViewController {
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minTextField: UITextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    static func instantiateWithTabbarItem() -> UINavigationController {
        let storyboard = UIStoryboard(name: "SettingViewController", bundle: nil)
        let svc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
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
