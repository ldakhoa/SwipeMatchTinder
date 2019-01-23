//
//  RegistrationViewModel.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 23/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var fullname: String? {
        didSet {
            checkFormValidity()
        }
        
    }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    // Reactive Programming
    var isFormValidObserver: ( (Bool) -> () )?
    
}
