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
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> Observable<ConnpassResponse>
}

/// SupporterzColabイベントデータプロバイダー
final class SupporterzColabDataProvider: SupporterzColabDataProviderProtocol {
    
    /// イベント情報を取得
    ///
    /// - Parameter searchQuery: 検索クエリ
    /// - Returns: Observable(ConnpassResponse)
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> Observable<ConnpassResponse> {
        
        let client = SupporterzColabAPIClient.shared
        guard let request = client.fetchEvents(searchQuery: searchQuery) else { return .empty() }
        
        return Observable<ConnpassResponse>.create { observer -> Disposable in
            request.responseJSON  { response in
                guard let data = response.data else { return }
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
