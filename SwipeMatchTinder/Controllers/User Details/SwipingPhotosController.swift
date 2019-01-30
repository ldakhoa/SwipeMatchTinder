//
//  SwipingPhotosController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 30/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var controllers = [UIViewController]()
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
                
            })
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
            
            setupBarStackViews()
        }
    }
    
    fileprivate let barsStackView = UIStackView()
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupBarStackViews() {
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = barDeselectedColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        
        view.addSubview(barsStackView)
        var paddingTop: CGFloat = 8
        if !isCardViewMode {
            paddingTop += UIApplication.shared.statusBarFrame.height
        }

        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate let isCardViewMode: Bool
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        dataSource = self
        delegate = self

        if isCardViewMode {
            disableSwipingAbility()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let currentController = viewControllers!.first!
        
        if let index = controllers.firstIndex(of: currentController) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
            if gesture.location(in: self.view).x > view.frame.width / 2 {
                let nextIndex = min(index + 1, controllers.count - 1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false, completion: nil)

                barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            } else {
                let previousIndex = max(0, index - 1)
                let nextController = controllers[previousIndex]
                setViewControllers([nextController], direction: .forward, animated: false, completion: nil)
                barsStackView.arrangedSubviews[previousIndex].backgroundColor = .white
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? -1
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex(where: {$0 == viewController}) ?? -1
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

