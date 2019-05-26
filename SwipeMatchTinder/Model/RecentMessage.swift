//
//  RecentMessage.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 26/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import Foundation
import Firebase

struct RecentMessage {
    let text, uid, name, profileImageUrl: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: .init())
    }
}
