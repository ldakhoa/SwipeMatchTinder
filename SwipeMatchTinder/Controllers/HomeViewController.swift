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
        
        // Fixes issue when switch to MessagesController
        navigationController?.navigationBar.isHidden = true
        
        addButtonsAction()
        setupLayout()
        fetchCurrentUser()
        
    }
    
    fileprivate func addButtonsAction() {
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handeLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handeDisLike), for: .touchUpInside)
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
        hud.textLabel.text = "Refresh"
        hud.show(in: view)
        // fix bug when refresh, it has card behind the card
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUserFromFirestore()
    }
    
    var topCardView: CardView?
    
    @objc func handeLike() {
        saveSwipeToFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)

    }
    
    @objc func handeDisLike() {
        saveSwipeToFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }

        let documentData = [cardUID: didLike]
        let swipesCollection = Firestore.firestore().collection("swipes").document(uid)
        swipesCollection.getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document \(err)")
                return
            }
            
            if didLike == 1 {
                self.checkIfMatchExists(cardUID: cardUID)
            }
            
            if snapshot?.exists == true {
                swipesCollection.updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data: \(err)")
                        return
                    }
                }
            } else {
                swipesCollection.setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data: \(err)")
                        return
                    }
                }
            }
        }
        
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch document for card user: \(err)")
                return
            }
            
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
                guard let cardUser = self.users[cardUID] else { return }
                let data: [String: Any] = ["name": cardUser.name ?? "", "profileImageUrl": cardUser.imageUrl1 ?? "", "uid": cardUID, "timestamp": Timestamp(date: Date())]
                Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(uid).collection("matches").document(cardUID).setData(data, completion: { (err) in
                    if let err = err {
                        print("Failed to save match info: \(err)")
                    }
                })
                
                guard let currentUser = self.user else { return }
                let otherMatchData: [String: Any] = ["name": currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl1 ?? "", "uid": currentUser.uid, "timestamp": Timestamp(date: Date())]
                Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(uid).collection("matches").document(uid).setData(otherMatchData, completion: { (err) in
                    if let err = err {
                        print("Failed to save match info: \(err)")
                    }
                })
                
            }
        }
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.isRemovedOnCompletion = false
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = 1
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    // This function from CardView, I put it to easy to follow logic of code
    // When user swipe image, the likeButton will not active
    // because in CardView -> handleEnded, we have removeFromSuperview()
    // did protocol solve this buggy we have
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    @objc fileprivate func handleMessages() {
        let vc = MatchesMassagesController()
        navigationController?.pushViewController(vc, animated: true)        
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
    var users = [String: User]()
    
    fileprivate func fetchUserFromFirestore() {

        let minAge = user?.minSeekingAge ?? SettingsTableViewController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsTableViewController.defaultMaxSeekingAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 10)
        
        topCardView = nil // Activate like and dislike button again went user save
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            if let err = err {
                print("Failed to fetch user: \(err.localizedDescription)")
                return
            }
            // we are going to set up the nextCardView relationship for all cards
            
            // Linked list
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.users[user.uid ?? ""] = user
                let currentUser = Auth.auth().currentUser?.uid
                let isNotCurrentUser = user.uid != currentUser
                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
//                if isNotCurrentUser && hasNotSwipedBefore {
                if isNotCurrentUser {
                    let cardView = self.setupCardFromUser(user: user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
                
            })
        }
    }

    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
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
            self.fetchSwipes()
            
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipes info for currently logged in user \(err)")
                return
            }
            guard let data = snapshot?.data() as? [String: Int] else { return }
            self.swipes = data
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

extension HomeViewController: CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsViewController()
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true, completion: nil)
    }

    
}
