//
//  NotificationService.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/23.
//  Copyright © 2019 ry-itto. All rights reserved.
//
import UserNotifications

protocol NotificationServiceProtocol where Self:UNUserNotificationCenterDelegate {
    /// ユーザに通知の許可を求める
    func requestAuthorization()
}

@available(iOS 10.0, *)
final class NotificationService: NSObject, UNUserNotificationCenterDelegate, NotificationServiceProtocol {
    func requestAuthorization() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert]) { granted, error in
            if let _ = error {
                return
            }
            
            if granted {
                notificationCenter.delegate = self
            }
        }
    }
}
