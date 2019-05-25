//
//  MessageCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 24/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.90670681, green: 0.9017671347, blue: 0.9060887694, alpha: 1))
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isFromCurrentUser {
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.06338243932, green: 0.7635894418, blue: 0.9986205697, alpha: 1)
                textView.textColor = .white
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.90670681, green: 0.9017671347, blue: 0.9060887694, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        bubbleContainer.layer.cornerRadius = 12
        setupLayout()
        
    }
    
    fileprivate func setupLayout() {
        addSubview(bubbleContainer)
        
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}
