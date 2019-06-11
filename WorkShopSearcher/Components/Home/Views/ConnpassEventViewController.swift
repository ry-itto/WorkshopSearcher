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
import SkeletonView
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
        let dataSource = EventDataSource(service: .connpass)
        viewModel.events
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.events
            .map { _ in false }
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
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
