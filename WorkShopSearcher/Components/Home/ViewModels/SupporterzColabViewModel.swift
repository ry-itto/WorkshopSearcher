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
    
    // output
    let events: Driver<[ConnpassResponse.Event]>
    let errorMessage: Signal<Error>
    
    init(_ provider: SupporterzColabDataProviderProtocol = SupporterzColabDataProvider()) {
        let eventsRelay = BehaviorRelay<[ConnpassResponse.Event]>(value: [])
        let errorMessage = PublishRelay<Error>()
        
        events = eventsRelay.asDriver()
        self.errorMessage = errorMessage.asSignal()
        
        let fetchEvents = viewDidLoad.asObservable()
            .flatMap { provider.fetchEvents(searchQuery: ConnpassRequest.SearchQuery()).materialize() }
        
        fetchEvents
            .flatMap { ($0.element?.events).map(Observable.just) ?? .empty() }
            .bind(to: eventsRelay)
            .disposed(by: disposeBag)
        
        fetchEvents
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .bind(to: errorMessage)
            .disposed(by: disposeBag)
    }
}