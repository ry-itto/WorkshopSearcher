//
//  LikeEvent.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/19.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RealmSwift

/// いいねしたイベント
final class LikeEvent: Object {
    /// ID
    @objc dynamic var id: Int = 0
    /// イベントタイトル
    @objc dynamic var title: String = ""
    /// イベント記事へのリンク
    @objc dynamic var urlString: String = ""
    /// イベント開始時刻
    @objc dynamic var startedAt: Date = Date()
    /// イベント参加上限
    @objc dynamic var limit: Int = 0
    /// 現在のイベントエントリー数
    @objc dynamic var present: Int = 0
    /// いいねしたかどうか
    @objc dynamic var liked: Bool = true

    override static func primaryKey() -> String? {
        return "id"
    }
}
