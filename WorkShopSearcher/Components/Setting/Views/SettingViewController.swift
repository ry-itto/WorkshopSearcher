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
            self.hourTextField.inputView = hourPicker.pickerView
            self.hourTextField.inputAccessoryView = hourPicker.toolBar
            
        }
    }
    @IBOutlet weak var minTextField: UITextField! {
        didSet {
            self.minTextField.inputView = minPicker.pickerView
            self.minTextField.inputAccessoryView = minPicker.toolBar
        }
    }
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    // Picker
    private var hourPicker = PickerViewParts()
    private var minPicker = PickerViewParts()
    
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
        nc.navigationBar.barTintColor = UIColor.Base.main.color()
        nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.Base.sub.color()]
        nc.navigationBar.tintColor = .white
        return nc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.viewDidLoad.accept(())
    }
    
    private func bindViewModel() {
        // Pickerの選択可能値をセット
        viewModel.hourValues
            .drive(hourPicker.pickerView.rx.itemTitles) { _, num in
                "\(num)"
            }.disposed(by: disposeBag)
        viewModel.minValues
            .drive(minPicker.pickerView.rx.itemTitles) { _, num in
                "\(num)"
            }.disposed(by: disposeBag)
        
        // 時間など選択時
        let hourSelected = hourPicker.pickerView.rx.modelSelected(Int.self)
            .distinctUntilChanged()
            .flatMap { $0.first.map(Observable.just) ?? .empty() }
            .share()
        hourSelected
            .map { "\($0)" }
            .bind(to: hourTextField.rx.text)
            .disposed(by: disposeBag)
        let minSelected = minPicker.pickerView.rx.modelSelected(Int.self)
            .distinctUntilChanged()
            .flatMap { $0.first.map(Observable.just) ?? .empty() }
            .share()
        minSelected
            .map { "\($0)" }
            .bind(to: minTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 値自体をセット
        viewModel.hourValue
            .map { "\($0)"}
            .drive(hourTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.minValue
            .map { "\($0)" }
            .drive(minTextField.rx.text)
            .disposed(by: disposeBag)
        viewModel.notificationEnable
            .drive(notificationSwitch.rx.value)
            .disposed(by: disposeBag)
        
        // Picker
        hourPicker.doneButton.rx.tap
            .bind(to: Binder(self) { me, _ in
                me.hourTextField.endEditing(true)
            }).disposed(by: disposeBag)
        hourPicker.doneButton.rx.tap
            .flatMap { [weak self] in
                Int(self?.hourTextField.text ?? "").map(Observable.just) ?? .empty()
            }
            .distinctUntilChanged()
            .bind(to: viewModel.setHour)
            .disposed(by: disposeBag)
        minPicker.doneButton.rx.tap
            .bind(to: Binder(self) { me, _ in
                me.minTextField.endEditing(true)
            }).disposed(by: disposeBag)
        minPicker.doneButton.rx.tap
            .flatMap { [weak self] in
                Int(self?.minTextField.text ?? "").map(Observable.just) ?? .empty()
            }
            .distinctUntilChanged()
            .bind(to: viewModel.setMin)
            .disposed(by: disposeBag)
        
        // Switch
        notificationSwitch.rx.value
            .bind(to: viewModel.setEnable)
            .disposed(by: disposeBag)
    }
}
