//
//  MatchCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 23/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView: UIImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    let usernameLabel = UILabel(text: "Username here", font: UIFont.systemFont(ofSize: 14, weight: .semibold), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            if let url = URL(string: item.profileImageUrl) {
                profileImageView.sd_setImage(with: url, completed: nil)
            }
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        stack(stack(profileImageView, alignment: .center),
              usernameLabel)
        
    }
    
}
