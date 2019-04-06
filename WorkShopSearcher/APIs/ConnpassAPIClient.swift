//
//  ConnpassAPIClient.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation

final class ConnpassAPIClient {
    private let requestURL: URL? = URL(string: "https://connpass.com/api/v1/event")
    init() {
        let searchQuery = ConnpassRequest.SearchQuery()
        searchQuery.createQueryItems()
    }
}
