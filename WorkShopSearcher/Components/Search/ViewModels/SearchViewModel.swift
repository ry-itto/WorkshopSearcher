//
//  SearchViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    private let disposeBag = DisposeBag()
    
    // input
    let search = PublishRelay<String>()
    
    // output
    let searchResult: Driver<[(service: Service, event: ConnpassResponse.Event)]>
    
    init(_ provider: SearchResultDataProviderProtocol = SearchResultDataProvider()) {
        let searchResultRelay = BehaviorRelay<[(service: Service, event: ConnpassResponse.Event)]>(value: [])
        
        self.searchResult = searchResultRelay.asDriver()
        
        // 検索された時に一度テーブルビューをリセットする
        search
            .map { _ in [] }
            .bind(to: searchResultRelay)
            .disposed(by: disposeBag)
        
        search
            .delay(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .flatMap{ provider.search(query: ConnpassRequest.SearchQuery(keyword: $0.components(separatedBy: " "))) }
            .bind(to: searchResultRelay)
            .disposed(by: disposeBag)
    }
}
