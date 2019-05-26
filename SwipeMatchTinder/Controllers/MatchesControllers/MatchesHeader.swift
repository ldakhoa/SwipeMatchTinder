//
//  MatchesHeader.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 26/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

class MatchesHeader: UICollectionReusableView {
    
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.9995308518, green: 0.4215543866, blue: 0.4476390481, alpha: 1))
    
    let matchesHorizontalController = MatchesHorizontalController()
    
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.9995308518, green: 0.4215543866, blue: 0.4476390481, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack(stack(newMatchesLabel).padLeft(20),
              matchesHorizontalController.view,
              stack(messagesLabel).padLeft(20),
              spacing: 20)
            .withMargins(.init(top: 20, left: 0, bottom: 8, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
