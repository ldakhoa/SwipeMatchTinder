//
//  CardViewModel.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 21/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

protocol ProducesCardViewModelDelegate {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    
    // define the properties that are view will display / render out
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
}


