//
//  MatchesMessagesController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 22/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools
import Firebase

class MatchesMassagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {

    let customNavBar = MatchesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        items = [
//            .init(name: "Test", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/swipematchtinder.appspot.com/o/images%2F6A5A42DA-534B-4B95-BB84-83488AE656C0?alt=media&token=85e48e4f-46d4-41e0-827f-f20f6b1a99ee"),
//            .init(name: "1", profileImageUrl: "profile url"),
//            .init(name: "2", profileImageUrl: "profile url"),
//
//        ]
        
        setupCollectionView()
        
        navigationController?.navigationBar.isHidden = true

        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
                
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 150))
        
        fetchMatches()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 150
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func fetchMatches() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("Failed to fetch matches: \(err)")
                return
            }
            
            var matches = [Match]()
            
            querySnapshot?.documents.forEach({ (documentSnapshot) in
                let dictionary = documentSnapshot.data()
                matches.append(.init(dictionary: dictionary))
                
            })
            
            self.items = matches
            self.collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
}