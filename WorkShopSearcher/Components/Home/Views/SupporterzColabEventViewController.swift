//
//  SupporterzColabEventViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class SupporterzColabEventViewController: UIViewController, IndicatorInfoProvider {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SupporterzColabViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: EventCell.cellIdentifier)
            tableView.rowHeight = EventCell.rowHeight
            tableView.refreshControl = UIRefreshControl()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Supporterz Colab")
    }
    
    private func bindViewModel() {
        guard let refreshControl = tableView.refreshControl else { return }
        
        viewModel.events
            .drive(tableView.rx.items(cellIdentifier: EventCell.cellIdentifier, cellType: EventCell.self)) { _, item, cell in
                cell.configure(service: .supporterz, event: item)
            }.disposed(by: disposeBag)
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
