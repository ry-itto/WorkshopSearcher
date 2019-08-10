//
//  EventDataSource.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/10.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// イベントデータソース
final class EventDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType, SectionedViewDataSourceType {

    typealias Element = [ConnpassResponse.Event]
    let service: Service
    var events: Element = []

    init(service: Service) {
        self.service = service
    }

    // tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.cellIdentifier, for: indexPath)
            as? EventCell else {
                assertionFailure("Failed cast to EventCell")
                return UITableViewCell()
        }
        if !events.isEmpty {
            cell.configure(service: service, event: events[indexPath.row])
        }

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.isEmpty ? 10 : events.count
    }

    // rx
    func tableView(_ tableView: UITableView, observedEvent: Event<EventDataSource.Element>) {
        Binder(self) { dataSource, events in
            dataSource.events = events
            tableView.reloadData()
        }.on(observedEvent)
    }

    func model(at indexPath: IndexPath) throws -> Any {
        if events.isEmpty {
            return ConnpassResponse.Event.emptyModel()
        }
        return events[indexPath.row]
    }
}
