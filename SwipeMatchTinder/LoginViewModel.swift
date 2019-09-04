//
//  LoginViewModel.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 29/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? { didSet { checkFormVadility() } }
    var password: String? { didSet { checkFormVadility() } }
    
    fileprivate func checkFormVadility() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping(Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
    
}
