//
//  ViewController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/11.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class SignUpController : UIViewController {
    
    //Outlets
    let addProfileImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "profileImage")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        return tf
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(red: 255, green: 137, blue: 35)
        button.tintColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    let hasAccountButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.3)])
        attributedText.append(NSMutableAttributedString(string: "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(red: 255, green: 137, blue: 35)]))
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()

    fileprivate func setupProfileImageButton() {
        view.addSubview(addProfileImageButton)
        
        let profileImageSize : CGFloat = 140
        addProfileImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: profileImageSize, height: profileImageSize)
        addProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addProfileImageButton.layer.cornerRadius = profileImageSize / 2
        addProfileImageButton.layer.masksToBounds = true
        addProfileImageButton.addTarget(self, action: #selector(handleAddProfileImage), for: .touchUpInside)
    }
    
    fileprivate func setupTextFieldsAndButton() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.anchor(top: addProfileImageButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 170)
        view.addSubview(signUpButton)
        signUpButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 50)
        signUpButton.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
    }
    
    fileprivate func setupLoginButton(){
        view.addSubview(hasAccountButton)
        hasAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 15)
        hasAccountButton.addTarget(self, action: #selector(handleHasAccountButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileImageButton()
        setupTextFieldsAndButton()
        setupLoginButton()
    }


}

extension SignUpController{
    
    @objc func handleAddProfileImage(){
        print("here is add profile image")
    }
    
    @objc func handleSignUpButton(){
        print("here is sign up button")
    }
    
    @objc func handleHasAccountButton(){
        print("here is has account button")
    }
}

