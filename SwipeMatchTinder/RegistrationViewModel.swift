//
//  RegistrationViewModel.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 23/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {

    var bindableIsRegistering = Bindable<Bool>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
        
    var fullname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }

    func checkFormValidity() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }

    // MARK: - Firebse Auth
    
    func performRegistration(completion: @escaping(Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                completion(err)
                return
            }
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping(Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping(Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let documentData: [String: Any] = [
            "email": email ?? "",
            "Age": 18,
            "fullName": fullname ?? "",
            "uid": uid,
            "imageUrl1": imageUrl,
            "minSeekingAge": SettingsTableViewController.defaultMinSeekingAge,
            "maxSeekingAge": SettingsTableViewController.defaultMaxSeekingAge
        ]
        
        Firestore.firestore().collection("users").document(uid).setData(documentData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            
            completion(nil)
            
        }
    }



    
}
