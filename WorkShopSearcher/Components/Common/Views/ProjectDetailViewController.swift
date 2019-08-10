//
//  ProjectDetailViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/17.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

class ProjectDetailViewController: UIViewController {

    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            likeButton.backgroundColor = UIColor.Base.main.color()
            likeButton.setImage(UIImage(named: "check_mark"), for: .selected)
            likeButton.setImage(UIImage(named: "good"), for: .normal)
        }
    }
    @IBOutlet weak var webView: WKWebView!

    private let disposeBag = DisposeBag()
    private let viewModel: ProjectDetailViewModel
    let likeEvent: LikeEvent

    init(event: Registerable, title: String = "") {
        self.likeEvent = event.transformToLikeEvent()
        self.viewModel = ProjectDetailViewModel()
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    init(event: LikeEvent, title: String = "") {
        self.likeEvent = event
        self.viewModel = ProjectDetailViewModel()
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.accept(likeEvent)
        guard let url = URL(string: likeEvent.urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        likeButton.layer.cornerRadius = 25
        likeButton.clipsToBounds = true
    }

    private func bindViewModel() {
        /// いいねボタンタップ時の処理
        likeButton.rx.tap
            .bind(to: Binder(self) { viewController, _ in
                viewController.viewModel.like.accept(viewController.likeEvent)
            }).disposed(by: disposeBag)
        /// いいねボタンの状態を変更
        viewModel.liked
            .drive(likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        /// DBに登録などが成功時
        viewModel.likeEventSuccess
            .bind(to: Binder(self) { viewController, _ in
                viewController.likeButton.isSelected = !viewController.likeButton.isSelected
            }).disposed(by: disposeBag)
        /// DBに登録などが失敗時
        viewModel.likeEventFailure
            .bind(to: Binder(self) { _, _ in
                // 失敗時のUIの処理
            }).disposed(by: disposeBag)
    }
}
