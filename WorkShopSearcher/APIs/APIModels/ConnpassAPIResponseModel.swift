//
//  ConnpassAPIResponseModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation

/// ConnpassAPIレスポンス用モデル
struct ConnpassResponse: Decodable {
    let resultsReturned: Int
    let resultsAvailable: Int
    let resultsStart: Int
    var events: [Event]

    /// Connpassイベントモデル
    struct Event: Decodable, Registerable {
        let eventID: Int
        let title: String
        let eventCatch: String
        let description: String
        let eventURL: URL
        let hashTag: String
        let startedAt: Date
        let endedAt: Date
        let limit: Int?
        let eventType: String
        let series: Series?
        let address: String?
        let place: String?
        let lat: String?
        let lon: String?
        let ownerID: Int
        let ownerNickname: String
        let ownerDisplayName: String
        let accepted: Int
        let waiting: Int
        let updatedAt: Date

        /// イベント開催グループモデル
        struct Series: Decodable {
            let id: Int
            let title: String
            let URL: URL

            enum CodingKeys: String, CodingKey {
                case id
                case title
                case URL = "url"
            }
        }

        enum CodingKeys: String, CodingKey {
            case eventID = "eventId"
            case title
            case eventCatch = "catch"
            case description
            case eventURL = "eventUrl"
            case hashTag
            case startedAt
            case endedAt
            case limit
            case eventType
            case series
            case address
            case place
            case lat
            case lon
            case ownerID = "ownerId"
            case ownerNickname
            case ownerDisplayName
            case accepted
            case waiting
            case updatedAt
        }

        /// いいねしたイベントに変換するメソッド
        ///
        /// - Returns: いいねしたイベントモデル
        func transformToLikeEvent() -> LikeEvent {
            let likeEvent = LikeEvent()
            likeEvent.title = self.title
            likeEvent.urlString = self.eventURL.absoluteString
            likeEvent.startedAt = self.startedAt
            likeEvent.limit = self.limit ?? 0
            likeEvent.present = self.accepted

            return likeEvent
        }

        /// 空のEventモデルかどうか判定
        ///
        /// - Returns: true: 空, false: 空でない
        func isEmptyModel() -> Bool {
            return self.eventID == 0 && self.title.isEmpty
        }

        /// 空のConnpassEventモデルを作成
        ///
        /// - Returns: 空のEventModel
        static func emptyModel() -> Event {
            return Event(eventID: 0,
                         title: "",
                         eventCatch: "",
                         description: "",
                         eventURL: URL(string: "http://example.com")!,
                         hashTag: "",
                         startedAt: Date(),
                         endedAt: Date(),
                         limit: nil,
                         eventType: "",
                         series: nil,
                         address: nil,
                         place: nil,
                         lat: nil,
                         lon: nil,
                         ownerID: 0,
                         ownerNickname: "",
                         ownerDisplayName: "",
                         accepted: 0,
                         waiting: 0,
                         updatedAt: Date())
        }
    }
}
