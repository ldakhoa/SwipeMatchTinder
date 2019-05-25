//
//  Message.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 24/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let text, fromId, toId: String
    let timestamp: Timestamp
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == self.fromId
    }
}
