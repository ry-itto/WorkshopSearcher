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
    let setEnable = PublishRelay<Bool>()
    
    // output
    let hourValues: Driver<[Int]>
    let minValues: Driver<[Int]>
    let hourValue: Driver<Int>
    let minValue: Driver<Int>
    let notificationEnable: Driver<Bool>
    
    init(_ notificationService: NotificationServiceProtocol = NotificationService(),
         _ userDefaultDataProvider: UserDefaultDataProviderProtocol = UserDefaultDataProvider()) {
        /// 時間ピッカーの値一覧
        let hourPickerValuesRelay = BehaviorRelay<[Int]>(value: Array(0...12))
        /// 分ピッカーの値一覧(5分おき)
        let minPickerValuesRelay = BehaviorRelay<[Int]>(value: (0...60).filter { $0 % 5 == 0 })
        
        let hourValueRelay = BehaviorRelay<Int>(value: 0)
        let minValueRelay = BehaviorRelay<Int>(value: 0)
        let notificationEnableRelay = BehaviorRelay<Bool>(value: true)
        
        self.hourValues = hourPickerValuesRelay.asDriver()
        self.minValues = minPickerValuesRelay.asDriver()
        self.hourValue = hourValueRelay.asDriver()
        self.minValue = minValueRelay.asDriver()
        self.notificationEnable = notificationEnableRelay.asDriver()
        
        viewDidLoad.asObservable()
            .debug()
            .subscribe(onNext: {
                notificationService.requestAuthorization()
            }).disposed(by: disposeBag)
        viewDidLoad.asObservable()
            .debug()
            .map { userDefaultDataProvider.getNotificationTimeBeforeHour() }
            .bind(to: hourValueRelay)
            .disposed(by: disposeBag)
        viewDidLoad.asObservable()
            .map { userDefaultDataProvider.getNotificationTimeBeforeMin() }
            .bind(to: minValueRelay)
            .disposed(by: disposeBag)
        
        // Binding
        setHour.asSignal()
            .emit(to: hourValueRelay)
            .disposed(by: disposeBag)
        setHour.asSignal()
            .emit(onNext: { hour in
                userDefaultDataProvider.setNotificationTimeBefore(hour: hour)
            }).disposed(by: disposeBag)
        setMin.asSignal()
            .emit(to: minValueRelay)
            .disposed(by: disposeBag)
        setMin.asSignal()
            .emit(onNext: { min in
                userDefaultDataProvider.setNotificationTimeBefore(min: min)
            }).disposed(by: disposeBag)
        setEnable.asSignal()
            .emit(to: Binder(self) { me, value in
                userDefaultDataProvider.setNotificationEnabled(enable: value)
            }).disposed(by: disposeBag)
    }
}
