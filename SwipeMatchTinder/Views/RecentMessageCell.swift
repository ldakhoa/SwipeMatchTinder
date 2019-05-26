//
//  RecentMessageCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 27/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools
import Firebase

class RecentMessageCell: LBTAListCell<RecentMessage> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "jane1.jpg"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "USERNAME HERE", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "some text long line of text that should span 2 lines", font: .systemFont(ofSize: 16), textColor: .gray, numberOfLines: 2)
    
    override var item: RecentMessage! {
        didSet {
            usernameLabel.text = item.name
            messageTextLabel.text = item.text
            if let url = URL(string: item.profileImageUrl) {
                userProfileImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        let size: CGFloat = 94
        userProfileImageView.layer.cornerRadius = size / 2
        
        hstack(userProfileImageView.withWidth(size).withHeight(size),
               stack(usernameLabel, messageTextLabel, spacing: 2),
               spacing: 20,
               alignment: .center
            ).padLeft(20).padRight(20)
        
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
        
    }
}
