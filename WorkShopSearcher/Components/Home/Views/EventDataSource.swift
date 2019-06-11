//
//  EventDataSource.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/10.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// イベントデータソース
final class EventDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [ConnpassResponse.Event]
    let service: Service
    var events: Element = []
    
    init(service: Service) {
        self.service = service
    }
    
    // tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.cellIdentifier, for: indexPath) as! EventCell
        if events.count != 0 {
            cell.configure(service: service, event: events[indexPath.row])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count == 0 ? 10 : events.count
    }
    
    // rx
    func tableView(_ tableView: UITableView, observedEvent: Event<EventDataSource.Element>) {
        Binder(self) { dataSource, events in
            dataSource.events = events
            tableView.reloadData()
        }.on(observedEvent)
    }
}
