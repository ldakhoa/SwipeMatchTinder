//
//  CardView.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 19/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {

            swipingPhotosController.cardViewModel = self.cardViewModel

            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment

            setupImageIndexObserver()
            
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        (0..<cardViewModel.imageUrls.count).forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = barDeselectedColor
            
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    // Configurations
    fileprivate let threshold: CGFloat = 80

    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    lazy var swipingPhotosView = swipingPhotosController.view!
    
    fileprivate let informationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()

    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMoreInfo() {
        self.delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))

    }
    
    // MARK: - Setup layout
    
    fileprivate func setupLayout() {
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
         // we must place this to display barsStackView > imageView > gradientLayer > informationLabel
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    let barsStackView = UIStackView()
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
    }
    
    override func layoutSubviews() {
        // in here you know what your CardView frame will be
        gradientLayer.frame = self.frame
    }
    
    // MARK: - Handle Pan Gesture
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            // fix some buggy animation when we swipe so fast
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            Void()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        // rotation
        // convert radians to degress
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * CGFloat.pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        if shouldDismissCard {
            guard let homeController = self.delegate as? HomeViewController else {return }
            self.isUserInteractionEnabled = false
            if translationDirection == 1 {
                homeController.handeLike()
            } else {
                homeController.handeDisLike()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

