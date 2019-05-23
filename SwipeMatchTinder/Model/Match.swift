//
//  Match.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 23/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import Foundation

struct Match {
    
    let name, profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
}
