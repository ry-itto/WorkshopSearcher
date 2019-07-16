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
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery, isRefresh: Bool) -> Observable<ConnpassResponse>
}

/// Connpassイベントデータプロバイダー
final class ConnpassDataProvider: ConnpassDataProviderProtocol {
    
    /// 検索終了フラグ
    private var searchEnd: Bool = false
    
    /// 検索の開始位置(default: 1)
    private var startPoint: Int = 1
    
    /// イベント情報を取得
    ///
    /// - Parameters:
    ///   - searchQuery: 検索クエリ
    ///   - isRefresh: 更新フラグ
    /// - Returns: Observable(ConnpassResponse)
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery, isRefresh: Bool) -> Observable<ConnpassResponse> {
        
        if isRefresh {
            self.startPoint = 1
        }
        
        let client = ConnpassAPIClient.shared
        searchQuery.updateStartPoint(startPoint: startPoint)
        
        guard
            !searchEnd,
            let request = client.fetchEvents(searchQuery: searchQuery)
        else {
            return .empty()
        }
        
        return Observable.create { [weak self] observer -> Disposable in
            request.responseJSON { response in
                if let err = response.error {
                    observer.onError(err)
                    return
                }
                
                guard let data = response.data else { return }
                do {
                    var decoded = try client.decoder.decode(ConnpassResponse.self, from: data)
                    decoded.events = decoded.events
                        .filter { event -> Bool in
                            event.startedAt.timeIntervalSinceNow > 0
                    }
                    observer.onNext(decoded)
                    if decoded.events.isEmpty {
                        self?.searchEnd = true
                    }
                    
                    /// 検索開始位置の更新
                    self?.startPoint += decoded.resultsReturned
                    
                    if decoded.resultsAvailable <= self?.startPoint ?? 1 {
                        self?.searchEnd = true
                    }
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
