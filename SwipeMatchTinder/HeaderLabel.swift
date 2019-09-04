//
//  HeaderLabel.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 27/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}
