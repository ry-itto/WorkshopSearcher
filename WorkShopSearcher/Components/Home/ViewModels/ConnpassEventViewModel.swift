//
//  ConnpassEventViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxSwift
import RxCocoa

final class ConnpassEventViewModel {
    
    private let disposeBag = DisposeBag()
    
    // input
    let viewDidLoad = PublishRelay<Void>()
    let refreshView = PublishRelay<Void>()
    let addEvents = PublishRelay<Void>()
    
    // output
    let events: Driver<[ConnpassResponse.Event]>
    let errorMessage: Signal<Error>
    
    init(_ provider: ConnpassDataProviderProtocol = ConnpassDataProvider()) {
        let errorMessage = PublishRelay<Error>()
        let eventsRelay = BehaviorRelay<[ConnpassResponse.Event]>(value: [])
        
        self.errorMessage = errorMessage.asSignal()
        self.events = eventsRelay.asDriver()
        
        let initializeEvents = Observable.merge(viewDidLoad.asObservable(),
                                                refreshView.asObservable())
        
        // viewDidLoad時検索条件なしでイベント情報を取得
        let fetchEvents = initializeEvents
            .flatMap { provider.fetchEvents(searchQuery: ConnpassRequest.SearchQuery(order: 3), isRefresh: true).materialize() }
        
        // 取得成功
        fetchEvents
            .flatMap { ($0.element?.events).map(Observable.just) ?? .empty() }
            .bind(to: eventsRelay)
            .disposed(by: disposeBag)
        
        // 取得失敗
        fetchEvents
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .bind(to: errorMessage)
            .disposed(by: disposeBag)
        
        let fetchAdditionalEvents =
            addEvents.asObservable()
                .flatMap { provider.fetchEvents(searchQuery: ConnpassRequest.SearchQuery(order: 3), isRefresh: false).materialize() }
        fetchAdditionalEvents
            .flatMap { ($0.element?.events).map(Observable.just) ?? .empty() }
            .map { eventsRelay.value + $0 }
            .bind(to: eventsRelay)
            .disposed(by: disposeBag)
        fetchAdditionalEvents
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .bind(to: errorMessage)
            .disposed(by: disposeBag)
    }
}
