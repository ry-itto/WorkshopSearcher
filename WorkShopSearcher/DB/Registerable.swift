//
//  Registerable.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/02.
//  Copyright © 2019 ry-itto. All rights reserved.
//

/// DB登録可能なモデルであるモデルに準拠するプロトコル
protocol Registerable {
    func transformToLikeEvent() -> LikeEvent
}
