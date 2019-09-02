//
//  EventCellViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/09/02.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

final class EventCellViewModel {

    private let disposeBag = DisposeBag()

    // input
    let fetchOGPImage = PublishRelay<URL>()

    // output
    let ogpImageURL = PublishRelay<URL>()

    init(_ provider: OGPImageDataProviderProtocol = OGPImageDataProvider()) {
        let fetched = fetchOGPImage.asObservable()
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .flatMap { provider.fetchImage(url: $0).materialize() }
            .share()
        fetched
            .flatMap { $0.element.map(Observable.just) ?? .empty() }
            .bind(to: ogpImageURL)
            .disposed(by: disposeBag)
        fetched
            .flatMap { $0.error.map(Observable.just) ?? .empty() }
            .debug()
    }
}
