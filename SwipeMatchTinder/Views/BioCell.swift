//
//  BioCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 30/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class BioCell: UITableViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Enter Bio"
//        tv.textColor = UIColor.officialApplePlaceholderGray
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.font = UIFont.systemFont(ofSize: 17)
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textView)
        let padding: CGFloat = 8

        textView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: padding, left: 16, bottom: 0, right: padding), size: .init(width: 0, height: 100))
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
