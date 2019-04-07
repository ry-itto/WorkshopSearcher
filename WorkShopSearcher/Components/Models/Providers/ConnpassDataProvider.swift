//
//  ConnpassDataProvider.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import RxSwift

protocol ConnpassDataProviderProtocol {
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> Observable<ConnpassResponse>
}

final class ConnpassDataProvider: ConnpassDataProviderProtocol {
    
    let client = ConnpassAPIClient.shared
    func fetchEvents(searchQuery: ConnpassRequest.SearchQuery) -> Observable<ConnpassResponse> {
        return .empty()
    }
}
