//
//  User.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 20/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModelDelegate {
    let name: String
    let age: Int
    let profession: String
    let imageNames: [String]
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .medium)]))
        
        let cardViewModel = CardViewModel(imageNames: imageNames, attributedString: attributedText, textAlignment: .left)
        return cardViewModel
    }
}


