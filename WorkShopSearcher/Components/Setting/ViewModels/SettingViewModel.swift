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
    
    // input
    let viewDidLoad = PublishRelay<Void>()
    let setHour = PublishRelay<Int>()
    let setMin = PublishRelay<Int>()
    
    // output
    let hourValues: Driver<[Int]>
    let minValues: Driver<[Int]>
    let hourValue: Driver<Int>
    let minValue: Driver<Int>
    
    init(_ notificationService: NotificationServiceProtocol = NotificationService()) {
        /// 時間ピッカーの値一覧
        let hourPickerValuesRelay = BehaviorRelay<[Int]>(value: Array(0...12))
        /// 分ピッカーの値一覧(5分おき)
        let minPickerValuesRelay = BehaviorRelay<[Int]>(value: (0...60).filter { $0 % 5 == 0 })
        
        let hourValueRelay = BehaviorRelay<Int>(value: 0)
        let minValueRelay = BehaviorRelay<Int>(value: 0)
        
        self.hourValues = hourPickerValuesRelay.asDriver()
        self.minValues = minPickerValuesRelay.asDriver()
        self.hourValue = hourValueRelay.asDriver()
        self.minValue = minValueRelay.asDriver()
        
        viewDidLoad.asObservable()
            .subscribe(onNext: {
                notificationService.requestAuthorization()
            }).disposed(by: disposeBag)
        
        // Binding
        setHour.asSignal()
            .emit(to: hourValueRelay)
            .disposed(by: disposeBag)
        
        setMin.asSignal()
            .emit(to: minValueRelay)
            .disposed(by: disposeBag)
    }
}
