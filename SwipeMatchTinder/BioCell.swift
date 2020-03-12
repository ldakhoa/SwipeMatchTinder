//
//  BioCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 30/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

final class BioCell: UITableViewCell {
    
    let textView: UITextView = {
        let tv = BioSettingsTextView()
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        tv.font = UIFont.systemFont(ofSize: 17)
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let view = UIView()
        
        addSubview(view)
        view.fillSuperview()
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        view.addSubview(textView)
        textView.fillSuperview()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
