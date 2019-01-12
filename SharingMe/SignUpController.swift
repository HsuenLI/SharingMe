//
//  ViewController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/11.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

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
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        return tf
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(red: 255, green: 223, blue: 182)
        button.tintColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = false
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

//Buttons target functionality
extension SignUpController {
    
    @objc func handleAddProfileImage(){
        
        
    }
    
    @objc func handleTextInput(){
        let isFormValidate = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0
        if isFormValidate{
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red: 255, green: 137, blue: 35)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 255, green: 223, blue: 182)
        }
    }
    
    @objc func handleSignUpButton(){
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0 else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error{
                print("Failed to sign up user: ", err)
                return
            }
            
            guard let uid = user?.user.uid  else {return}
            let usernameValues = ["username" : username]
            let values = [uid : usernameValues]
            
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let err = error{
                    print("Failed to save data into firebase: ", err)
                    return
                }
                
                print("Successful save data into firebase")
            })
        }
    }
    
    @objc func handleHasAccountButton(){
        print("here is has account button")
    }
}

