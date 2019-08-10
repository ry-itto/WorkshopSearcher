//
//  ConnpassAPIRequestModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation

/// ConnpassAPIリクエスト用モデル
enum ConnpassRequest {
    /// ConnpassAPI検索クエリモデル
    class SearchQuery {
        private let eventId: Int?
        private let keyword: [String]?
        private let keywordOr: [String]?
        private let ym: Int?
        private let ymd: Int?
        private let nickname: String?
        private let ownerNickname: String?
        private let seriesId: Int?
        private var start: Int?
        private let order: Int?
        private let count: Int?
        private let format: String?

        init(eventId: Int? = nil,
             keyword: [String]? = nil,
             keywordOr: [String]? = nil,
             ym: Int? = nil,
             ymd: Int? = nil,
             nickname: String? = nil,
             ownerNickname: String? = nil,
             seriesId: Int? = nil,
             start: Int? = nil,
             order: Int? = nil,
             count: Int? = nil,
             format: String? = nil) {
            self.eventId = eventId
            self.keyword = keyword
            self.keywordOr = keywordOr
            self.ym = ym
            self.ymd = ymd
            self.nickname = nickname
            self.ownerNickname = ownerNickname
            self.seriesId = seriesId
            self.start = start
            self.order = order
            self.count = count
            self.format = format
        }

        /// 検索開始位置を更新する
        ///
        /// - Parameter startPoint: 更新後の検索開始位置
        func updateStartPoint(startPoint: Int) {
            self.start = startPoint
        }

        /// 検索クエリの情報からqueryItemsを作成する
        ///
        /// - Returns: 入力された検索条件を持つqueryItems
        func createQueryItems() -> [URLQueryItem] {
            var queryItems: [URLQueryItem] = []
            if let eventId = eventId {
                queryItems.append(URLQueryItem(name: "event_id", value: "\(eventId)"))
            }
            if let keyword = keyword {
                let joined = keyword.joined(separator: ",")
                queryItems.append(URLQueryItem(name: "keyword", value: joined))
            }
            if let keywordOr = keywordOr {
                let joined = keywordOr.joined(separator: ",")
                queryItems.append(URLQueryItem(name: "keyword_or", value: joined))
            }
            if let ym = ym {
                queryItems.append(URLQueryItem(name: "ym", value: "\(ym)"))
            }
            if let ymd = ymd {
                queryItems.append(URLQueryItem(name: "ymd", value: "\(ymd)"))
            }
            if let nickname = nickname {
                queryItems.append(URLQueryItem(name: "nick_name", value: "\(nickname)"))
            }
            if let ownerNickname = ownerNickname {
                queryItems.append(URLQueryItem(name: "owner_nickname", value: "\(ownerNickname)"))
            }
            if let seriesId = seriesId {
                queryItems.append(URLQueryItem(name: "series_id", value: "\(seriesId)"))
            }
            if let start = start {
                queryItems.append(URLQueryItem(name: "start", value: "\(start)"))
            }
            if let order = order {
                queryItems.append(URLQueryItem(name: "order", value: "\(order)"))
            }
            if let count = count {
                queryItems.append(URLQueryItem(name: "count", value: "\(count)"))
            }
            if let format = format {
                queryItems.append(URLQueryItem(name: "format", value: "\(format)"))
            }
            return queryItems
        }
    }
}
