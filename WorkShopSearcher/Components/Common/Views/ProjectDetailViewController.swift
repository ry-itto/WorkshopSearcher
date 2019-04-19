//
//  ProjectDetailViewController.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/17.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import WebKit

class ProjectDetailViewController: UIViewController {

    @IBOutlet weak var goodButton: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    let url: URL
    
    init(url: URL, title: String = "") {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url)
        webView.load(request)
        goodButton.layer.cornerRadius = 25
        goodButton.clipsToBounds = true
    }
}
