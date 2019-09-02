//
//  OGPImageDataProvider.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/09/02.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import Foundation
import OpenGraph
import RxSwift

protocol OGPImageDataProviderProtocol {
    /// 与えられたウェブサイトのOGP画像を取得
    ///
    /// - Parameter url: ウェブサイトURL
    /// - Returns: Observable<OGP画像URL
    ///     - onNext: 画像取得成功
    ///     - onCompleted: 画像取得失敗
    func fetchImage(url: URL) -> Observable<URL>
}

final class OGPImageDataProvider: OGPImageDataProviderProtocol {
    func fetchImage(url: URL) -> Observable<URL> {
        return Observable.create { observer -> Disposable in
            OpenGraph.fetch(url: url) { openGraph, error in
                guard error == nil,
                    let imageURLString = openGraph?[.image],
                    let imageURL = URL(string: imageURLString) else {
                        observer.onCompleted()
                        return
                }

                observer.onNext(imageURL)
            }
            return Disposables.create()
        }
    }
}
