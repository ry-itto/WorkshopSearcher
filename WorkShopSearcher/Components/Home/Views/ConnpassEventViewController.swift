//
//  ConnpassEventViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class ConnpassEventViewController: UIViewController, IndicatorInfoProvider {
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: EventCell.cellIdentifier)
            tableView.rowHeight = EventCell.rowHeight
            tableView.refreshControl = UIRefreshControl()
        }
    }
    
    private let viewModel = ConnpassEventViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Connpass")
    }
    
    private func bindViewModel() {
        guard let refreshControl = tableView.refreshControl else { return }
        // tableView
        viewModel.events
            .drive(tableView.rx.items(cellIdentifier: EventCell.cellIdentifier, cellType: EventCell.self)) { _, item, cell in
                cell.configure(service: .connpass, event: item)
            }.disposed(by: disposeBag)
        viewModel.events
            .map { _ in false }
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        // セルがタップされた時WebViewでイベントページを開く
        tableView.rx.modelSelected(ConnpassResponse.Event.self)
            .asSignal()
            .emit(to: Binder(self) {me, event in
                me.navigationController?.pushViewController(ProjectDetailViewController(event: event, title: "Connpass"), animated: true)
            }).disposed(by: disposeBag)
        // セルタップ時セルの選択状態を解除
        tableView.rx.itemSelected
            .asSignal()
            .emit(to: Binder(self) { me, indexPath in
                me.tableView.cellForRow(at: indexPath)?.isSelected = false
            }).disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: Binder(self) { me, _ in
                // TODO:- エラー処理
            }).disposed(by: disposeBag)
        
        // pull to refresh
        let refreshView = refreshControl.rx.controlEvent(.valueChanged).asSignal()
        refreshView
            .emit(to: viewModel.refreshView)
            .disposed(by: disposeBag)
        refreshView
            .map{ true }
            .emit(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
