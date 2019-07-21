//
//  SettingViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/19.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: UITableViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = SettingViewModel()
    
    @IBOutlet weak var hourTextField: UITextField! {
        didSet {
            self.hourTextField.inputView = hourPicker
        }
    }
    @IBOutlet weak var minTextField: UITextField! {
        didSet {
            self.minTextField.inputView = minPicker
        }
    }
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    // Picker
    private let hourPicker = UIPickerView()
    private let minPicker = UIPickerView()
    
    override var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    static func instantiateWithTabbarItem() -> UINavigationController {
        let storyboard = UIStoryboard(name: "SettingViewController", bundle: nil)
        let svc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        svc.title = "設定"
        let nc = UINavigationController(rootViewController: svc)
        nc.title = "設定"
        nc.tabBarItem.image = UIImage(named: "setting")
        return nc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }
    
    private func bindViewModel() {
        viewModel.hourValues
            .drive(hourPicker.rx.itemTitles) { _, num in
                "\(num)"
            }.disposed(by: disposeBag)
        viewModel.minValues
            .drive(minPicker.rx.itemTitles) { _, num in
                "\(num)"
            }.disposed(by: disposeBag)
        let hourSelected = hourPicker.rx.modelSelected(Int.self)
            .distinctUntilChanged()
            .flatMap { $0.first.map(Observable.just) ?? .empty() }
            .share()
        hourSelected
            .bind(to: viewModel.setHour)
            .disposed(by: disposeBag)
        hourSelected
            .map { "\($0)" }
            .bind(to: hourTextField.rx.text)
            .disposed(by: disposeBag)
        let minSelected = minPicker.rx.modelSelected(Int.self)
            .distinctUntilChanged()
            .flatMap { $0.first.map(Observable.just) ?? .empty() }
            .share()
        minSelected
            .bind(to: viewModel.setMin)
            .disposed(by: disposeBag)
        minSelected
            .map { "\($0)" }
            .bind(to: minTextField.rx.text)
            .disposed(by: disposeBag)
    }
}
