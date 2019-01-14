//
//  LogOutController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/13.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //Outlet
    let bannerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 255, green: 137, blue: 35)
        return view
    }()
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "logo_white")?.withRenderingMode(.alwaysOriginal)
        return imageView
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
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(red: 255, green: 223, blue: 182)
        button.tintColor = .white
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.isEnabled = false
        return button
    }()
    
    let withoutAccoutnButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.3)])
        attributedText.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor(red: 255, green: 137, blue: 35)]))
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupBannerView()
        setupLoginTextField()
        setupSignUpButton()
    }
}

extension LoginController{
    
    fileprivate func setupBannerView() {
        view.addSubview(bannerView)
        bannerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
        bannerView.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: bannerView.leftAnchor, bottom: nil, right: bannerView.rightAnchor, paddingTop: 0, paddingLeft: 30, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        logoImageView.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor).isActive = true
    }
    
    fileprivate func setupLoginTextField(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: bannerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 170)
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
    }
    
    fileprivate func setupSignUpButton(){
        view.addSubview(withoutAccoutnButton)
        withoutAccoutnButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 15)
        withoutAccoutnButton.addTarget(self, action: #selector(handleWithoutAccountButton), for: .touchUpInside)
    }
}

extension LoginController{
    @objc func handleTextInput(){
        let isFormValidate = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValidate{
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red: 255, green: 137, blue: 35)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 255, green: 223, blue: 182)
        }
    }
    
    @objc func handleLoginButton(){
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error{
                print("Failed to signin to firebase:", error)
                return
            }
            print("Successfully sign in to firebase: ", user?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarController.setupControllers()
            self.dismiss(animated: true, completion: nil)            
        })

    }
    
    @objc func handleWithoutAccountButton(){
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
