//
//  AppDelegate.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/05.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // DB
        DBManager.configure()

        // window
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vcs = [
            HomeViewController.instantiateWithTabbarItem(),
            SearchViewController.instantiateWithTabbarItem(),
            LikeListViewController.instantiateWithTabBarItem(),
            SettingViewController.instantiateWithTabbarItem()
        ]
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = vcs
        tabBarController.tabBar.tintColor = UIColor.Base.main.color()
        window.rootViewController = tabBarController
        self.window = window
        self.window?.makeKeyAndVisible()

        return true
    }
}
