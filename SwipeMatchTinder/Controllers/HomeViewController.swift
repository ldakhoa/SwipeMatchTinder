//
//  ViewController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 19/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeViewController: UIViewController {
    
    fileprivate var user: User?
    let hud = JGProgressHUD(style: .dark)
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()

    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationViewController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)

            present(navController, animated: true, completion: nil)
        }

    }
    
    // MARK: - Handle method
    
    @objc fileprivate func handleSettings() {
        let settingsController = SettingsTableViewController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUserFromFirestore()
    }

    // MARK: - Layout
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
         
        overallStackView.bringSubviewToFront(cardsDeckView)

    }
    
    // MARK: - Fetch from Firestore
    
    var lastFetchedUser: User?
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func fetchUserFromFirestore() {

        let minAge = user?.minSeekingAge ?? SettingsTableViewController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsTableViewController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge).whereField("age", isLessThan: maxAge)
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch user: \(err.localizedDescription)")
                return
            }
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
//                self.cardViewModels.append(user.toCardViewModel())
//                self.lastFetchedUser = user
                let currentUser = Auth.auth().currentUser?.uid
                if user.uid != currentUser {
                    self.setupCardFromUser(user: user)
                }
                
            })
        }
    }
    
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user \(err)")
                self.hud.dismiss()
                return
            }
            
            self.user = user
            self.fetchUserFromFirestore()
        }
    }

}

extension HomeViewController: SettingsControllerDelegate, LoginControllerDelegate {
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    func didFinishLogingIn() {
        fetchCurrentUser()
    }
}

