//
//  Firestore+Utils.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 28/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import Firebase

extension Firestore {
    
    func fetchCurrentUser(completion: @escaping(User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch user in setting\(err)")
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user, nil)
            
        }
    }    
}

