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

// View Model is supposed represent the State of our View
class CardViewModel {
    
    // define the properties that are view will display / render out
    let uid: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(uid: String, imageUrls: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageUrls
        self.attributedString = attributedString
        self.textAlignment = textAlignment
        self.uid = uid
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageUrls[imageIndex]
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    // Reactive Programming
    var imageIndexObserver: ( (Int, String?) -> () )?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)

    }

    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}


