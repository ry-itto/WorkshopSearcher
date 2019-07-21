//
//  SettingViewModel.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/19.
//  Copyright © 2019 ry-itto. All rights reserved.
//
import RxSwift
import RxCocoa

final class SettingViewModel {
    private let disposeBag = DisposeBag()
    
    /// 定数
    /// 時間ピッカーの値一覧
    let hourPickerValues: [Int] = Array((0...12))
    
    /// 分ピッカーの値一覧
    let minPickerValues: [Int] = Array((0...60))
    
    // input
    let viewDidLoad = PublishRelay<Void>()
    let setHour = PublishRelay<Int>()
    let setMin = PublishRelay<Int>()
    
    // output
    let hourValue: Driver<Int>
    let minValue: Driver<Int>
    
    init() {
        let hourValueRelay = BehaviorRelay<Int>(value: 0)
        let minValueRelay = BehaviorRelay<Int>(value: 0)
        
        self.hourValue = hourValueRelay.asDriver()
        self.minValue = minValueRelay.asDriver()
        
        // Binding
        setHour.asSignal()
            .emit(to: hourValueRelay)
            .disposed(by: disposeBag)
        
        setMin.asSignal()
            .emit(to: minValueRelay)
            .disposed(by: disposeBag)
    }
}
