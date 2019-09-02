//
//  SupporterzColabDataProvider.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/08.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift

/// SupporterzColabイベントデータプロバイダープロトコル
protocol SupporterzColabDataProviderProtocol {
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery, isRefresh: Bool) -> Observable<ConnpassResponse>
}

/// SupporterzColabイベントデータプロバイダー
final class SupporterzColabDataProvider: SupporterzColabDataProviderProtocol {

    /// 検索終了フラグ
    private var searchEnd: Bool = false

    /// 検索の開始位置(default: 1)
    private var startPoint: Int = 1

    /// イベント情報を取得
    ///
    /// - Parameter searchQuery: 検索クエリ
    /// - Returns: Observable(ConnpassResponse)
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery, isRefresh: Bool) -> Observable<ConnpassResponse> {

        if isRefresh {
            self.startPoint = 1
        }

        let client = SupporterzColabAPIClient.shared
        searchQuery.updateStartPoint(startPoint: startPoint)

        guard
            !searchEnd,
            let request = client.fetchEvents(searchQuery: searchQuery)
            else {
                return .empty()
        }

        return Observable<ConnpassResponse>.create { observer -> Disposable in
            request.responseJSON { [weak self] response in
                if let err = response.error {
                    observer.onError(err)
                    return
                }

                guard let data = response.data else {
                    return
                }
                do {
                    var decoded = try client.decoder.decode(ConnpassResponse.self, from: data)
                    decoded.events = decoded.events
                        .filter { event -> Bool in
                            event.startedAt.timeIntervalSinceNow > 0
                        }
                    if decoded.events.isEmpty {
                        self?.searchEnd = true
                    }
                    observer.onNext(decoded)

                    /// 検索開始位置の更新
                    self?.startPoint += decoded.resultsReturned

                    if decoded.resultsAvailable <= self?.startPoint ?? 1 {
                        self?.searchEnd = true
                    }
                } catch let err {
                    observer.onError(err)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }

    }
}
