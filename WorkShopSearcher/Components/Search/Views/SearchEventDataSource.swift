//
//  SearchEventDataSource.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/11.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// 検索画面イベントデータソース
final class SearchEventDataSource:
NSObject, UITableViewDataSource, RxTableViewDataSourceType, SectionedViewDataSourceType {

    typealias Element = [(service: Service, event: ConnpassResponse.Event)]
    var events: Element = []
    var searched: Bool = false

    // tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.cellIdentifier, for: indexPath)
            as? EventCell else {
                assertionFailure("Failed cast to EventCell")
                return UITableViewCell()
        }
        if !events.isEmpty {
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
        return searched && events.isEmpty ? 10 : events.count
    }

    // rx
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, events in
            dataSource.events = events
            tableView.reloadData()
        }.on(observedEvent)
    }

    func model(at indexPath: IndexPath) throws -> Any {
        if events.isEmpty {
            return (service: Service.connpass, event: ConnpassResponse.Event.emptyModel())
        }
        return events[indexPath.row]
    }
}
