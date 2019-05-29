//
//  ChatLogController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 24/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools
import Firebase

class ChatLogController: LBTAListController<MessageCell, Message> {
    
    deinit {
        print("Chatlog Object is destroing itself properly, no retain cycles of any other memory related issue. Memory being reclaimed properly")
    }
    
    fileprivate lazy var messagesNavBar = MessagesNavBar(match: match)
    
    fileprivate let navBarHeight: CGFloat = 120
    
    fileprivate let match: Match
    
    static let matchesMsgCollection = "matches_messages"
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    // MARK: - Input accessory view

    lazy var customInputAccessView: CustomInputAccessView = {
        let civ = CustomInputAccessView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()

    override var inputAccessoryView: UIView? {
        get {
            return customInputAccessView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupLayout()
        messagesNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        fetchMessages()
        fetchCurrentUser()
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = navBarHeight
        collectionView.alwaysBounceVertical = true
        collectionView.scrollIndicatorInsets.top = navBarHeight
        collectionView.keyboardDismissMode = .interactive
        
    }
    
    fileprivate func setupLayout() {
        view.addSubview(messagesNavBar)
        messagesNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: 0, height: navBarHeight))
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    // MARK: - Action method
    
    @objc fileprivate func handleKeyboardShow() {
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func handleSend() {
        saveFromMessages()
        saveFromRecentMessages()
    }
    
    // TODO: - Refactor this, too!

    fileprivate func saveFromMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let collection = Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(currentUserId).collection(match.uid)
        let data: [String: Any] = ["text": customInputAccessView.textView.text ?? "", "fromId": currentUserId, "toId": match.uid, "timestamp": Timestamp(date: Date())]
        
        collection.addDocument(data: data) { (err) in
            if let err = err {
                print("Failed to save message: \(err)")
                return
            }
            self.customInputAccessView.textView.text = nil
            self.customInputAccessView.placeHolderLabel.isHighlighted = false
        }
        
        let toCollection = Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(match.uid).collection(currentUserId)
        toCollection.addDocument(data: data) { (err) in
            if let err = err {
                print("Failed to save message: \(err)")
                return
            }
            self.customInputAccessView.textView.text = nil
            self.customInputAccessView.placeHolderLabel.isHighlighted = false
        }
    }
    
    fileprivate func saveFromRecentMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let query = Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(currentUserId).collection("recent_messages").document(match.uid)
        let data: [String: Any] = ["text": customInputAccessView.textView.text ?? "", "name": match.name, "profileImageUrl": match.profileImageUrl, "timestamp": Timestamp(date: Date()), "uid": match.uid]
        
        query.setData(data) { (err) in
            if let err = err {
                print("Failed to save recent msg \(err)")
                return
            }
            
        }
        
        // save the other direction

        guard let currentUser = self.currentUser else { return }
        let toData: [String: Any] = ["text": customInputAccessView.textView.text ?? "", "name": currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl1 ?? "", "timestamp": Timestamp(date: Date()), "uid": currentUserId]
        Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(match.uid).collection("recent_messages").document(currentUserId).setData(toData) { (err) in
            if let err = err {
                print("Failed to save recent msg \(err)")
                return
            }
            
        }
        
    }
    
    var currentUser: User?
    
    fileprivate func fetchCurrentUser() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUserId).getDocument { (snapshot, err) in
            let data: [String: Any] = snapshot?.data() ?? [:]
            self.currentUser = User(dictionary: data)
        }
    }
    
    var listener: ListenerRegistration?
    
    fileprivate func fetchMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection(ChatLogController.matchesMsgCollection).document(currentUserId).collection(match.uid).order(by: "timestamp")
        listener = query.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Failed to fetch msg: \(err)")
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    self.items.append(.init(dictionary: dictionary))
                    
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // tells you if its being popped off the nav stack
        if isMovingFromParent {
            listener?.remove()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }

}
