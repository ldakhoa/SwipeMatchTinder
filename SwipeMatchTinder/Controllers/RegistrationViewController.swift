//
//  RegistrationViewController.swift
//  SwipeMatchTinder
//
//  Created by Le Doan Anh Khoa on 23/1/19.
//  Copyright © 2019 Le Doan Anh Khoa. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
//        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullname = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
        button.layer.cornerRadius = 55 / 2
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.setTitleColor(.darkGray, for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            print(res?.user.uid ?? "")
        }
        
    }
    
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        setupRegistrationViewModelObserver()
        
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
            self.registerButton.isEnabled = isFormValid
            if isFormValid {
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8140897155, green: 0.09555955976, blue: 0.3356131911, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    // MARK: - Layout
    
//    var overallStackViewCenterY: NSLayoutConstraint?
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [fullNameTextField, emailTextField, passwordTextField, registerButton])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [selectPhotoButton, verticalStackView])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
            selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true 
//            view.addSubview(scrollView)
//            scrollView.fillSuperview()
//
//            scrollView.contentSize = view.frame.size
//            scrollView.addSubview(overallStackView)
//            overallStackViewCenterY?.isActive = false
//            overallStackViewCenterY = overallStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
//            overallStackViewCenterY?.isActive = true
            
        } else {
            overallStackView.axis = .vertical
//            view.addSubview(overallStackView)
//            overallStackViewCenterY?.isActive = false
//            overallStackViewCenterY = overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            overallStackViewCenterY?.isActive = true
            
        }
    }
    
    fileprivate func setupLayout() {
        overallStackView.axis = .vertical
        overallStackView.spacing = 10
        
        view.addSubview(overallStackView)
        // fix height of button to support landscape mode

        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 40, bottom: 0, right: 40))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradientLayer.frame = view.bounds
        
    }
    
    // MARK: - Handle Keyboard show / hide
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    let scrollView = UIScrollView()
//
//    var activeTextField: UITextField?
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        activeTextField = textField
//    }

    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        // figure out how tall the gap is from the register button to the bottom of the screen
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
//        scrollView.contentInset.bottom = keyboardFrame.height
//        scrollView.scrollIndicatorInsets.bottom = keyboardFrame.height
//
//        guard let activeTextField = activeTextField else { return }
//        let visibleRect = activeTextField.convert(activeTextField.bounds, to: scrollView)
//        scrollView.scrollRectToVisible(visibleRect, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self) // you'll have a retain cycle
        
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
//            self.scrollView.contentInset.bottom = 0
        })
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true) // dismiss keyboard
    }
    
}
