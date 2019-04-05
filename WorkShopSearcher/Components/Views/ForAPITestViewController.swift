//
//  ForAPITestViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/06.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ForAPITestViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.rx.text.asObservable()
            .bind(to: outputTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
