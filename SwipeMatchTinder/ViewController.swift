//
//  ViewController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 19/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let buttonsStackView = HomeBottomControlsStackView()
    let blueView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }

    // MARK: - Fileprivate
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }

}

