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

final class SearchViewController: UIViewController {
    
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
        let dataSource = SearchEventDataSource()
        
        searchBar.rx.searchButtonClicked
            .flatMap { [weak self] in
                self?.searchBar.text.map(Observable.just) ?? .empty()
            }
            .filter { !$0.isEmpty }
            .do(onNext: { _ in
                dataSource.searched = true
            })
            .bind(to: viewModel.search)
            .disposed(by: disposeBag)
        
        // table view
        viewModel.searchResult
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
