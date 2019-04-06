//
//  ConnpassAPIClient.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ConnpassAPIClient {
    private let requestURL: URL? = URL(string: "https://connpass.com/api/v1/event")
    
    /// ConnpassAPIを用いてイベント情報を取得
    ///
    /// - Parameter searchQuery: 検索クエリ
    /// - Returns: リクエスト
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> DataRequest? {
        guard let requestURL = requestURL else { return nil }
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        components?.queryItems = searchQuery.createQueryItems()
        guard let url = components?.url else { return nil }
        
        return Alamofire.request(url)
    }
}
