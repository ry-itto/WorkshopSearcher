//
//  SearchEventDataSource.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 検索画面イベントデータソース
final class SearchEventDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [(service: Service, event: ConnpassResponse.Event)]
    var events: Element = []
    var searched: Bool = false
    
    // tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.cellIdentifier, for: indexPath) as! EventCell
        if events.count != 0 {
            let event = events[indexPath.row]
            cell.configure(service: event.service, event: event.event)
        } else {
            cell.showAllAnimatedSkeleton()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searched && events.count == 0 ? 10 : events.count
    }
    
    // rx
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, events in
            dataSource.events = events
            tableView.reloadData()
        }.on(observedEvent)
    }
}
