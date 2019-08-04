//
//  ProjectDetailViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/02.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProjectDetailViewModel {
    
    private let disposeBag = DisposeBag()
    
    /// input
    let viewDidLoad = PublishRelay<LikeEvent>()
    let like = PublishRelay<LikeEvent>()
    
    /// output
    let liked: Driver<Bool>
    let likeEventSuccess: Observable<Void>
    let likeEventFailure: Observable<Error>
    
    init(_ notificationService: NotificationServiceProtocol = NotificationService(),
         _ dbManager: DBManagerProtocol = DBManager()) {
        /// 初期化時いいねボタンの状態を操作
        self.liked = viewDidLoad
            .map(dbManager.isLiked)
            .asDriver(onErrorJustReturn: false)
        
        /// いいねしたイベント登録/更新
        let likeEvent = like.asObservable()
            .flatMap { likeEvent -> Observable<Event<Void>> in
                if dbManager.isExisted(item: likeEvent) {
                    
                    if dbManager.isLiked(item: likeEvent) {
                        // 変える前にいいねしている場合
                        notificationService.cancelNotification(eventID: likeEvent.id)
                    } else {
                        // 変える前にいいねしていない場合
                        _ = notificationService.registerNotification(eventID: likeEvent.id, title: likeEvent.title, body: "", holdDate: likeEvent.startedAt)
                    }
                    return dbManager.toggleLikeState(item: likeEvent).materialize()
                } else {
                    _ = notificationService.registerNotification(eventID: likeEvent.id, title: likeEvent.title, body: "", holdDate: likeEvent.startedAt)
                    return dbManager.create(item: likeEvent).materialize()
                }
            }.share()
        self.likeEventSuccess = likeEvent // 追加成功時処理
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .asObservable()
        self.likeEventFailure = likeEvent // 追加失敗時処理
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .asObservable()
    }
}
