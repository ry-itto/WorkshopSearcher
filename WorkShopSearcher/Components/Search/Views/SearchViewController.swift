 //
//  SearchViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: EventCell.cellIdentifier)
            tableView.rowHeight = EventCell.rowHeight
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    static func instantiateWithTabbarItem() -> UINavigationController {
        let svc = SearchViewController()
        svc.title = "検索"
        let nc = UINavigationController(rootViewController: svc)
        nc.title = "検索"
        nc.tabBarItem.image = UIImage(named: "search")
        return nc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        searchBar.rx.text.asObservable()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .filter { !($0?.isEmpty ?? true) }
            .flatMap{ $0.map(Observable.just) ?? Observable.empty() }
            .bind(to: viewModel.search)
            .disposed(by: disposeBag)
        
        // table view
        viewModel.searchResult
            .drive(tableView.rx.items(cellIdentifier: EventCell.cellIdentifier, cellType: EventCell.self)) { _, item, cell in
                cell.configure(service: item.service, event: item.event)
            }.disposed(by: disposeBag)
    }
}
