//
//  UserDefaultDataProvider.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/23.
//  Copyright © 2019 ry-itto. All rights reserved.
//
import Foundation

protocol UserDefaultDataProviderProtocol {
    /// 通知ON/OFFをセット
    ///
    /// - Parameter enable: true ON, false OFF
    func setNotificationEnabled(enable: Bool)
    
    /// 通知ON/OFF状態を取得
    ///
    /// - Returns: true: ON, false: OFF
    func isNotificationEnabled() -> Bool
    
    ///  通知時間(時間)をセット
    ///
    /// - Parameter hour: 時間
    func setNotificationTimeBefore(hour: Int)
    
    /// 通知時間(時間)を取得
    ///
    /// - Returns: 時間
    func getNotificationTimeBeforeHour() -> Int
    
    /// 通知時間(分)をセット
    ///
    /// - Parameter min: 分
    func setNotificationTimeBefore(min: Int)
    
    /// 通知時間(分)を取得
    ///
    /// - Returns: 分
    func getNotificationTimeBeforeMin() -> Int
}

final class UserDefaultDataProvider: UserDefaultDataProviderProtocol {
    func setNotificationEnabled(enable: Bool) {
        UserDefaults.standard.set(enable, forKey: "notification.enabled")
    }
    
    func isNotificationEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "notification.enabled")
    }
    
    func setNotificationTimeBefore(hour: Int) {
        UserDefaults.standard.set(hour, forKey: "notification.time.hour")
    }
    
    func getNotificationTimeBeforeHour() -> Int {
        return UserDefaults.standard.integer(forKey: "notification.time.hour")
    }
    
    func setNotificationTimeBefore(min: Int) {
        UserDefaults.standard.set(min, forKey: "notification.time.min")
    }
    
    func getNotificationTimeBeforeMin() -> Int {
        return UserDefaults.standard.integer(forKey: "notification.time.min")
    }
}
