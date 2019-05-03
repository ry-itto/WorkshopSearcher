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
    let events: [Event]
    
    /// Connpassイベントモデル
    struct Event: Decodable {
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
    }
}
