//
//  ChatLogController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 24/5/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import LBTATools

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var messagesNavBar = MessagesNavBar(match: match)
    
    fileprivate let navBarHeight: CGFloat = 120
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    // MARK: - Input accessory view

    
    lazy var customInputAccessView: UIView = {
        let view = CustomInputAccessView()
        return CustomInputAccessView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    
    
    
    override var inputAccessoryView: UIView? {
        get {
            return customInputAccessView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        items = [
            .init(text: "Hello HelloHelloHelloHelloHelloHello Hello Hello Hello Hello Hello HelloHello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello HelloHello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Hello Khoa ne", isFromCurrentUser: true),
            .init(text: "Hello", isFromCurrentUser: false),
            .init(text: "Hello My Van", isFromCurrentUser: true),
            .init(text: "Hello Khoa, I'm Van, I'm from Vietnam, my favorite hobby is Sing, Cook, learn something new, I am try to be a singer and can perform in big big stage, or to be a direction of file in HollyWood, or to be a direction of file in HollyWood, or to be a direction of file in HollyWood, or to be a direction of file in HollyWood, that it.", isFromCurrentUser: false),
        ]
        
        setupLayout()
        messagesNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
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
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
