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
        
        let client = SupporterzColabAPIClient()
        let request = client.fetchEvents(searchQuery: ConnpassRequest.SearchQuery())
        
        request?.responseJSON { [unowned self] response in
            Observable.just(String(data: response.data!, encoding: .utf8))
                .bind(to: self.outputTextView.rx.text)
                .disposed(by: self.disposeBag)
        }
        
        inputTextField.rx.text.asObservable()
            .bind(to: outputTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
