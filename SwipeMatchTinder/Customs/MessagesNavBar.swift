//
//  MessagesNavBar.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 24/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "lady4c"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 1, green: 0.3552635908, blue: 0.3608631492, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 1, green: 0.3552635908, blue: 0.3608631492, alpha: 1))
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init(frame: .zero)
        
        nameLabel.text = match.name
        if let url = URL(string: match.profileImageUrl) {
            userProfileImageView.sd_setImage(with: url, completed: nil)
        }
        
        setupLayout()

        
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        
        let middleStack = hstack(
            stack(userProfileImageView,
                  nameLabel,
                  spacing: 8,
                  alignment: .center),
            alignment: .center
        )
        
        hstack(backButton.withWidth(50),
               middleStack,
               flagButton).withMargins(.init(top: 0, left: 4, bottom: 0, right: 16))
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
