//
//  LikeListViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/12.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxSwift
import RxCocoa

final class LikeListViewModel {
    private let disposeBag = DisposeBag()
    
    // input
    let viewWillAppear = PublishRelay<Void>()
    
    // output
    let likeEvents: Driver<[LikeEvent]>
    
    init(_ dbManager: DBManager = DBManager.shared) {
        let likeEventsRelay = BehaviorRelay<[LikeEvent]>(value: [])
        
        self.likeEvents = likeEventsRelay.asDriver()
        
        viewWillAppear.asObservable()
            .flatMap { _ in dbManager.fetchAllLikeEvents() }
            .bind(to: likeEventsRelay)
            .disposed(by: disposeBag)
    }
}
