//
//  ConnpassAPIRequestModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation

enum ConnpassRequest {
    struct SearchQuery {
        private let eventId: Int? = nil
        private let keyword: [String]? = nil
        private let keywordOr: [String]? = nil
        private let ym: Int? = nil
        private let ymd: Int? = nil
        private let nickname: String? = nil
        private let ownerNickname: String? = nil
        private let seriesId: Int? = nil
        private let start: Int? = nil
        private let order: Int? = nil
        private let count: Int? = nil
        private let format: String? = nil
        
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
