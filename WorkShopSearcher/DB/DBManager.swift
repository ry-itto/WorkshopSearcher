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
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    /// いいねイベント登録
    ///
    /// - Parameter item: イベントモデル
    /// - Returns: Observable
    func create(item: LikeEvent) -> Observable<Void> {
        return Observable.create { [unowned self] observer -> Disposable in
            let maxId = self.realm.objects(LikeEvent.self).sorted(byKeyPath: "id").last?.id ?? 0
            item.id = maxId + 1
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
    
    /// いいねイベント削除
    ///
    /// - Parameter item: イベントモデル
    /// - Returns: Obseevable
    func delete(item: LikeEvent) -> Observable<Void> {
        let object = realm.objects(LikeEvent.self).filter("urlString == %@", item.urlString).first!
        return Observable.create { [unowned self] observer -> Disposable in
            do {
                try self.realm.write {
                    self.realm.delete(object)
                }
                observer.onNext(())
            } catch(let e) {
                observer.onError(e)
            }
            return Disposables.create()
        }
    }
    
    /// 指定したいいねイベントのlikedパラメータを反転
    ///
    /// - Parameter item: イベントモデル
    /// - Returns: Observable
    func toggleLikeState(item: LikeEvent) -> Observable<Void> {
        let object = realm.objects(LikeEvent.self).filter("urlString == %@", item.urlString).first!
        return Observable.create { [unowned self] observer -> Disposable in
            do {
                try self.realm.write {
                    object.liked = !object.liked
                    observer.onNext(())
                }
            } catch (let e) {
                observer.onError(e)
            }
            return Disposables.create()
        }
    }
    
    /// 引数に与えたモデルが登録されているか判定
    ///
    /// - Parameter item: イベントモデル
    /// - Returns: 登録されている: true, 登録されていない: false
    func isExisted(item: LikeEvent) -> Bool {
        let object = realm.objects(LikeEvent.self).filter("urlString == %@", item.urlString).first
        switch object {
        case .some:
            return true
        case .none:
            return false
        }
    }
    
    /// 引数に与えたモデルがいいねされているものか判定
    /// 存在しない場合falseを返却する
    ///
    /// - Parameter item: イベントモデル
    /// - Returns: いいねされている: true, いいねされていない: false
    func isLiked(item: LikeEvent) -> Bool {
        guard let object = realm.objects(LikeEvent.self).filter("urlString == %@", item.urlString).first else { return false }
        return object.liked
    }
    
    /// 全てのいいねしたイベント情報を取得
    ///
    /// - Returns: 全てのいいねしたイベント情報
    func fetchAllLikeEvents() -> Observable<[LikeEvent]> {
        let objects = realm.objects(LikeEvent.self).filter("liked == true")
        return Observable.create { observer -> Disposable in
            observer.onNext(Array(objects))
            return Disposables.create()
        }
    }
}
