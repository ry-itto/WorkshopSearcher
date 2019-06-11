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

/// 検索画面
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
    
    /// タブバーアイテムに値をセットし、初期化
    ///
    /// - Returns: タブバーアイテムに値がセットされたVC
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
        
        // 検索ボタンが押された時
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
        
        // セルがタップされた時WebViewでイベントページを開く
        tableView.rx.modelSelected((service: Service, event: ConnpassResponse.Event).self)
            .asSignal()
            .emit(to: Binder(self) {me, event in
                me.navigationController?.pushViewController(ProjectDetailViewController(event: event.event, title: ""), animated: true)
            }).disposed(by: disposeBag)
        // セルタップ時セルの選択状態を解除
        tableView.rx.itemSelected
            .asSignal()
            .emit(to: Binder(self) { me, indexPath in
                me.tableView.cellForRow(at: indexPath)?.isSelected = false
            }).disposed(by: disposeBag)
    }
}
