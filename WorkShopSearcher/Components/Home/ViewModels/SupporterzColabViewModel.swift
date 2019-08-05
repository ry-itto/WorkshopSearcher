//
//  SupporterzColabViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/08.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SupporterzColabViewModel {
    
    private let disposeBag = DisposeBag()
    
    // input
    let viewDidLoad = PublishRelay<Void>()
    let refreshView = PublishRelay<Void>()
    let addEvents = PublishRelay<Void>()
    
    // output
    let events: Driver<[ConnpassResponse.Event]>
    let errorMessage: Signal<Error>
    
    init(_ provider: SupporterzColabDataProviderProtocol = SupporterzColabDataProvider()) {
        let eventsRelay = BehaviorRelay<[ConnpassResponse.Event]>(value: [])
        let errorMessage = PublishRelay<Error>()
        
        events = eventsRelay.asDriver()
        self.errorMessage = errorMessage.asSignal()
        
        let initializeEvents = Observable.merge(viewDidLoad.asObservable(),
                            refreshView.asObservable())
        
        let fetchEvents = initializeEvents
            .flatMap { provider.fetchEvents(searchQuery: ConnpassRequest.SearchQuery(order: 3), isRefresh: true).materialize() }
        
        fetchEvents
            .flatMap { ($0.element?.events).map(Observable.just) ?? .empty() }
            .bind(to: eventsRelay)
            .disposed(by: disposeBag)
        
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
