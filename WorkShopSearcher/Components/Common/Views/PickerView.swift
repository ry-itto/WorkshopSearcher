//
//  PickerView.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/07/22.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

final class PickerViewParts {
    
    private(set) var pickerView: UIPickerView!
    private(set) var toolBar: UIToolbar!
    private(set) var doneButton: UIBarButtonItem!
    
    init() {
        createView()
    }
    
    private func createView() {
        /// Toolbar for picker
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), doneButton], animated: true)
        self.toolBar = toolbar
        self.doneButton = doneButton
        
        /// Picker
        let pickerView = UIPickerView()
        pickerView.frame.size.width = 40
        self.pickerView = pickerView
    }
}
