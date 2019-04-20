//
//  DBManager.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/20.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

final class DBManager {
    
    let realm: Realm = try! Realm()
    
    static let shared = DBManager()
    
    private init() {}
    
    static func configure() {
        let config = Realm.Configuration(schemaVersion: 0)
        Realm.Configuration.defaultConfiguration = config
    }
    
    /// いいねイベント登録
    ///
    /// - Parameter item: イベントモデル
    /// - Returns: Observable
    func create(item: LikeEvent) -> Observable<Void> {
        return Observable.create { [unowned self] observer -> Disposable in
            do {
                try self.realm.write {
                    self.realm.add(item)
                }
                observer.onNext(())
            } catch (let e) {
                observer.onError(e)
            }
            return Disposables.create()
        }
    }
}
