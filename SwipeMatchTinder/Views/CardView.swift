//
//  CardView.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 19/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            // accessing index 0 will crash if imageNames.count == 0
            let imageName = cardViewModel.imageUrls.first ?? ""
            // load image using url
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url, completed: nil)
                imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder").withRenderingMode(.alwaysOriginal), options: .continueInBackground, completed: nil)
            }

            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
            
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, imageUrl) in
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder").withRenderingMode(.alwaysOriginal), options: .continueInBackground, completed: nil)
            }
            
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    
    fileprivate let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
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
    
    @objc fileprivate func handleMoreInfo() {
        self.delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    // MARK: - Setup layout
    
    fileprivate func setupLayout() {
        addSubview(imageView)
        imageView.fillSuperview()
         // we must place this to display barsStackView > imageView > gradientLayer > informationLabel
        setupBarsStackView()
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
    
    // MARK: - Handle Pan / Tap Gesture
    
    var imageIndex = 0    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }

    }
    
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

        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
            
            } else {
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

