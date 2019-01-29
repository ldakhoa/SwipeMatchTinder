//
//  Advertiser.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 21/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModelDelegate {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        return CardViewModel(imageUrls: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
    }
}

