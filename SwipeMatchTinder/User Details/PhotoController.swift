//
//  PhotoController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 30/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

// This controller is used for CardView and SwipingPageController

import UIKit

final class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "photo_placeholder"))
    
    init(imageUrl: String) {
        super.init(nibName: nil, bundle: nil)
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        imageView.fillSuperview()
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
