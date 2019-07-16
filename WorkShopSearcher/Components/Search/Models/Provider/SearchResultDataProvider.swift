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
    ///
    /// - Parameter query: 検索するキーワード
    /// - Returns: 検索結果
    func search(query: ConnpassRequest.SearchQuery) -> Observable<[(service: Service, event: ConnpassResponse.Event)]>
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
    
    func search(query: ConnpassRequest.SearchQuery) -> Observable<[(service: Service, event: ConnpassResponse.Event)]> {
        return Observable.create { [unowned self] observer -> Disposable in
            let event = Observable.zip(
                self.connpassDataProvider.fetchEvents(searchQuery: query, isRefresh: false).materialize(),
                self.supporterzColabDataProvider.fetchEvents(searchQuery: query, isRefresh: false).materialize()
                ).share()
            event.flatMap { (connpass, supporterz) -> Observable<[(service: Service, event: ConnpassResponse.Event)]> in
                
                let cEvents = connpass.element?.events ?? []
                let sEvents = supporterz.element?.events ?? []
                
                if let err = connpass.error {
                    observer.onError(err)
                    return .empty()
                }
                if let err = supporterz.error {
                    observer.onError(err)
                    return .empty()
                }
                
                let cDicEvents: [(service: Service, event: ConnpassResponse.Event)] = cEvents.map { event -> (service: Service, event: ConnpassResponse.Event) in
                    return (service: Service.connpass, event: event)
                }
                let sDicEvents: [(service: Service, event: ConnpassResponse.Event)] = sEvents.map { event -> (service: Service, event: ConnpassResponse.Event) in
                    return (service: Service.supporterz, event: event)
                }
                return .just(cDicEvents + sDicEvents)
            }
            .subscribe(onNext: { events in
                observer.onNext(self.sortByStartDate(events))
            }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    /// イベントを開始日付でソート
    ///
    /// - Parameter events: イベントの配列
    /// - Returns: ソート済みイベント配列
    private func sortByStartDate(_ events: [(service: Service, event: ConnpassResponse.Event)]) -> [(service: Service, event: ConnpassResponse.Event)] {
        return events.sorted(by: { (aDic, bDic) -> Bool in
            return aDic.event.startedAt > bDic.event.startedAt
        })
    }
}
