//
//  LikeListViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/06/12.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class LikeListViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = LikeListViewModel()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "EventCell", bundle: nil),
                               forCellReuseIdentifier: EventCell.cellIdentifier)
            tableView.rowHeight = EventCell.rowHeight
            tableView.tableFooterView = UIView()
        }
    }

    static func instantiateWithTabBarItem() -> UINavigationController {
        let viewController = LikeListViewController()
        viewController.title = "いいねしたイベント一覧"
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: "heart")
        navigationController.title = "いいねしたイベント一覧"
        navigationController.navigationBar.barTintColor = UIColor.Base.main.color()
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Base.sub.color()]
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.accept(())
    }

    private func bindViewModel() {
        viewModel.likeEvents
            .drive(tableView.rx.items(cellIdentifier: EventCell.cellIdentifier,
                                      cellType: EventCell.self)) { _, event, cell in
                                        cell.configure(likeEvent: event)
            }.disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(to: Binder(self) { viewController, indexPath in
                viewController.tableView.cellForRow(at: indexPath)?.isSelected = false
            }).disposed(by: disposeBag)

        tableView.rx.modelSelected(LikeEvent.self)
            .bind(to: Binder(self) { viewController, event in
                viewController.navigationController?.pushViewController(
                    ProjectDetailViewController(event: event), animated: true)
            }).disposed(by: disposeBag)
    }
}
