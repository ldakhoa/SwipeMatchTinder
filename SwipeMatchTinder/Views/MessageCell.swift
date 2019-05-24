//
//  MessageCell.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 24/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

class MessageCell: LBTAListCell<Message> {
    
    override var item: Message! {
        didSet {
            backgroundColor = .red
            
        }
    }
    
}
