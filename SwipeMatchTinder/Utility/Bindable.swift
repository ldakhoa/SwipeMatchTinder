//
//  Bindable.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 25/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping(T?) -> ()) {
        self.observer = observer
    }
}
