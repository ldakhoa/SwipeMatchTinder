//
//  LogoutCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 31/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {

    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9652562737, green: 0.3096027374, blue: 0.6150571108, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .white
        return button
    }()
    
    let view: UIView = {
        let v = UIView()
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        addSubview(view)
        view.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 44))
        view.addSubview(logoutButton)
        logoutButton.fillSuperview()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
