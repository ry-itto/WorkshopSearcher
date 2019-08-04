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
    
    /// 通知の登録をする
    ///
    /// - Parameters:
    ///   - eventID: イベントID
    ///   - title: 通知タイトル
    ///   - body: 通知内容
    ///   - holdDate: 開催日
    /// - Returns: identifier(イベントID)
    func registerNotification(eventID: Int, title: String, body: String, holdDate: Date) -> String
    
    /// 通知の登録をする(複数)
    ///
    /// - Parameter events: 通知一覧
    func registerNotifications(events: [LikeEvent])
    
    /// 通知の更新をする
    ///
    /// - Parameter events: イベント一覧
    func updateNotifications(events: [LikeEvent])
    
    /// 通知の取り消しをする
    ///
    /// - Parameter eventID: イベントID
    func cancelNotification(eventID: Int)
    
    /// 全通知の取り消しをする
    func cancelAllNotifications()
    
    /// 配信前の通知を取得する
    ///
    /// - Parameter completion: 配信前の通知一覧に対する処理
    func getPendingNotificationRequests(completion: @escaping ([UNNotificationRequest]) -> Void)
    
    /// 配信後の通知を取得する
    ///
    /// - Parameter completion: 配信後の通知一覧に対する処理
    func getDeliveredNotificationRequests(completion: @escaping ([UNNotification]) -> Void)
}

@available(iOS 10.0, *)
final class NotificationService: NSObject, UNUserNotificationCenterDelegate, NotificationServiceProtocol {
    
    private let userDefaultsDataProvider: UserDefaultDataProviderProtocol
    
    init(_ userDefaultsDataProvider: UserDefaultDataProviderProtocol = UserDefaultDataProvider()) {
        self.userDefaultsDataProvider = userDefaultsDataProvider
    }
    
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
    
    func registerNotification(eventID: Int, title: String, body: String, holdDate: Date) -> String {
        let identifier = "\(eventID)"
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let calendar = Calendar.current
        let holdHour = calendar.component(.hour, from: holdDate)
        let holdMin = calendar.component(.minute, from: holdDate)
        
        let notificationBeforeHour = userDefaultsDataProvider.getNotificationTimeBeforeHour()
        let notificationBeforeMin = userDefaultsDataProvider.getNotificationTimeBeforeMin()
        
        var notificationHour = holdHour - notificationBeforeHour
        var notificationMin: Int = holdMin
        if notificationMin - notificationBeforeMin < 0 {
            notificationHour -= 1
            notificationMin = 60 - notificationBeforeMin
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: holdDate)
        dateComponents.month = calendar.component(.month, from: holdDate)
        dateComponents.day = calendar.component(.day, from: holdDate)
        dateComponents.hour = notificationHour
        dateComponents.minute = notificationMin
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { err in
            if let err = err {
                assertionFailure(err.localizedDescription)
            }
        }
        
        return identifier
    }
    
    func registerNotifications(events: [LikeEvent]) {
        events.forEach { event in
            _ = registerNotification(eventID: event.id, title: event.title, body: "", holdDate: event.startedAt)
        }
    }
    
    func updateNotifications(events: [LikeEvent]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        registerNotifications(events: events)
    }
    
    func cancelNotification(eventID: Int) {
        let identifier = "\(eventID)"
        
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func getPendingNotificationRequests(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: completion)
    }
    
    func getDeliveredNotificationRequests(completion: @escaping ([UNNotification]) -> Void) {
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: completion)
    }
}
