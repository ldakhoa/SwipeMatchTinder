//
//  UserDetailsViewController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 29/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UIScrollViewDelegate {

    let swipingPhotosController = SwipingPhotosController()
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never // Not contain safeAreaLayoutGuide
        sv.delegate = self
        return sv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()
    
    let dislikeButton = HomeBottomControlsStackView.createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = HomeBottomControlsStackView.createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = HomeBottomControlsStackView.createButton(image: #imageLiteral(resourceName: "like_circle"))
    
    @objc fileprivate func handleTapDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControls()
        
        dislikeButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        
    }
    
    // MARK: - Layout
    
    lazy var swipingView = swipingPhotosController.view!
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(swipingView)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 24), size: .init(width: 50, height: 50))
    }
    
    fileprivate let extraSwipingHeight: CGFloat = 80
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Auto layout in ScrollView is not same behavior like Normal UIView, so use frame instead of auto layout
        swipingView.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraSwipingHeight)
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -32
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = scrollView.contentOffset.y
        var width = view.frame.width - changeY * 2
        width = max(view.frame.width, width)
        let x = min(0, changeY)
        
        swipingView.frame = .init(x: x, y: x, width: width, height: width + extraSwipingHeight)
    }



}
