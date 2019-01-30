//
//  UserDetailsViewModel.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 30/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

protocol ProducesUserDetailsViewModelDelegate {
    func toUserDetailsModel() -> UserDetailsViewModel
}

class UserDetailsViewModel {
    
    // define the properties that are view will display / render out
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageUrls: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageUrls
        self.attributedString = attributedString
        self.textAlignment = textAlignment
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
