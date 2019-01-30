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
        let paddingTop = UIApplication.shared.statusBarFrame.height + 8
        barsStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: paddingTop, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentPhotoController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        dataSource = self
        delegate = self

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


    
}

