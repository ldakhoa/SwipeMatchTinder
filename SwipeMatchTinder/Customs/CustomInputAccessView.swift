//
//  CustomInputAccessView.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 25/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

final class CustomInputAccessView: UIView {
    
    let textView = UITextView()
    
    let sendButton = UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
    
    let placeHolderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    //    let messageImageView = UIImageView(image: , contentMode: .scaleAspectFill)
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
        
        hstack(
            textView,
            sendButton.withSize(.init(width: 60, height: 60)),
            alignment: .center
        ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
        addSubview(placeHolderLabel)
        
        placeHolderLabel.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: nil,
            trailing: sendButton.leadingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 0)
        )
        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    
    @objc fileprivate func handleTextChange() {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
