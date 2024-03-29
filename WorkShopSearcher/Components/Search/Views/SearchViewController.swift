//
//  SearchViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/05/13.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/// 検索画面
final class SearchViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "EventCell", bundle: nil),
                               forCellReuseIdentifier: EventCell.cellIdentifier)
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
        let navigationController = UINavigationController(rootViewController: svc)
        navigationController.title = "検索"
        navigationController.tabBarItem.image = UIImage(named: "search")
        navigationController.navigationBar.barTintColor = UIColor.Base.main.color()
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Base.sub.color()]
        navigationController.navigationBar.tintColor = .white
        return navigationController
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
        searchBar.rx.searchButtonClicked
            .bind(to: Binder(self) { viewController, _ in
                viewController.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)

        // table view
        viewModel.searchResult
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.errorMessage
            .emit(to: Binder(self) { viewController, _ in
                viewController.showConnectionAlert()
            }).disposed(by: disposeBag)

        // セルがタップされた時WebViewでイベントページを開く
        tableView.rx.modelSelected((service: Service, event: ConnpassResponse.Event).self)
            .asSignal()
            .filter { !$0.event.isEmptyModel() }
            .emit(to: Binder(self) {viewController, event in
                viewController.navigationController?.pushViewController(
                    ProjectDetailViewController(event: event.event, title: ""), animated: true)
            }).disposed(by: disposeBag)
        // セルタップ時セルの選択状態を解除
        tableView.rx.itemSelected
            .asSignal()
            .emit(to: Binder(self) { viewController, indexPath in
                viewController.tableView.cellForRow(at: indexPath)?.isSelected = false
            }).disposed(by: disposeBag)
        tableView.rx.contentOffset
            .distinctUntilChanged()
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .filter {
                dataSource.searched && ($0.y + self.tableView.bounds.height) / self.tableView.contentSize.height > 0.8
            }
            .map { _ in self.searchBar.text ?? "" }
            .bind(to: viewModel.addEvents)
            .disposed(by: disposeBag)
    }
}
