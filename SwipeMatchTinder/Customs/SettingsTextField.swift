//
//  SettingsTextField.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 27/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class SettingsTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 44)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 24, dy: 0)
    }
}
