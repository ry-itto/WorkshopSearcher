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
        viewModel.events
            .drive(tableView.rx.items(cellIdentifier: EventCell.cellIdentifier, cellType: EventCell.self)) { _, item, cell in
                cell.configure(service: .supporterz, event: item)
            }.disposed(by: disposeBag)
    }
}
