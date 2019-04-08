//
//  ConnpassDataProvider.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxSwift

/// Connpassイベントデータプロバイダープロトコル
protocol ConnpassDataProviderProtocol {
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> Observable<ConnpassResponse>
}

/// Connpassイベントデータプロバイダー
final class ConnpassDataProvider: ConnpassDataProviderProtocol {
    
    /// イベント情報を取得
    ///
    /// - Parameter searchQuery: 検索クエリ
    /// - Returns: Observable(ConnpassResponse)
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> Observable<ConnpassResponse> {
        
        let client = ConnpassAPIClient.shared
        guard let request = client.fetchEvents(searchQuery: searchQuery) else {
            return .empty()
        }
        
        return Observable.create { observer -> Disposable in
            request.responseJSON { response in
                guard let data = response.data else { return }
                try! client.decoder.decode(ConnpassResponse.self, from: data)
                do {
                    let decoded = try client.decoder.decode(ConnpassResponse.self, from: data)
                    observer.onNext(decoded)
                } catch(let e) {
                    observer.onError(e)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
