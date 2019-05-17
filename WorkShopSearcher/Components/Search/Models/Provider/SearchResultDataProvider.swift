//
//  SearchResultDataProvider.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/14.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol SearchResultDataProviderProtocol {
    /// 検索する
    /// onErrorを流さない実装になっています。
    ///
    /// - Parameter query: 検索するキーワード
    /// - Returns: 検索結果
    func search(query: ConnpassRequest.SearchQuery) -> Observable<[ConnpassResponse.Event]>
}

final class SearchResultDataProvider: SearchResultDataProviderProtocol {
    
    private let disposeBag = DisposeBag()
    
    let connpassDataProvider: ConnpassDataProviderProtocol
    let supporterzColabDataProvider: SupporterzColabDataProviderProtocol
    
    init(connpass: ConnpassDataProviderProtocol = ConnpassDataProvider(),
         supporterz: SupporterzColabDataProviderProtocol = SupporterzColabDataProvider()) {
        self.connpassDataProvider = connpass
        self.supporterzColabDataProvider = supporterz
    }
    
    func search(query: ConnpassRequest.SearchQuery) -> Observable<[ConnpassResponse.Event]> {
        return Observable.create { [unowned self] observer -> Disposable in
            let event = Observable.zip(
                self.connpassDataProvider.fetchEvents(searchQuery: query).materialize(),
                self.supporterzColabDataProvider.fetchEvents(searchQuery: query).materialize()
                ).share()
            event.flatMap { (connpass, supporterz) -> Observable<[ConnpassResponse.Event]> in
                guard
                    let cEvents = connpass.element?.events,
                    let sEvents = supporterz.element?.events else { return .empty() }
                return .just(cEvents + sEvents)
                }.subscribe(onNext: { events in
                    observer.onNext(self.sortByStartDate(events))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    /// イベントを開始日付でソート
    ///
    /// - Parameter events: イベントの配列
    /// - Returns: ソート済みイベント配列
    private func sortByStartDate(_ events: [ConnpassResponse.Event]) -> [ConnpassResponse.Event] {
        return events.sorted { (a, b) -> Bool in
            return a.startedAt > b.startedAt
        }
    }
}
