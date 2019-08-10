//
//  ConnpassAPIClient.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Alamofire
import Foundation

/// ConnpassAPIクライアント
class ConnpassAPIClient {

    /// APIリクエストURL
    let requestURL: URL? = URL(string: "https://connpass.com/api/v1/event")

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    static let shared = ConnpassAPIClient()

    private init() {}

    /// ConnpassAPIを用いてイベント情報を取得
    ///
    /// - Parameter searchQuery: 検索クエリ
    /// - Returns: リクエスト
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> DataRequest? {
        guard let requestURL = requestURL else { return nil }
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        components?.queryItems = searchQuery.createQueryItems()
        guard let url = components?.url else { return nil }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)

        return Alamofire.request(request)
    }
}
