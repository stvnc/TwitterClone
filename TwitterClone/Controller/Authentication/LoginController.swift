//
//  LoginController.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 18/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit
import Firebase

class LoginController : UIViewController {
    // MARK : - Properties
    
    
    
    private let logoImageView: UIImageView =  {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
        
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField =  {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(withAttribute: "Dont have an account? Sign Up", titleColor: .white, backgroundColor: .twitterBlue)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    // MARK : - Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK : - Selectors
    
    @objc func handleLogin(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        AuthService.shared.logUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("DEBUG: Error while logging user in \(error.localizedDescription)")
            }else{
                print("DEBUG: Successfully logged user in")
                let navToMain = MainTabController()
                //navToMain.modalPresentationStyle = .fullScreen
                //self.present(navToMain, animated: true, completion: nil)
                
                self.navigationController?.pushViewController(navToMain, animated: true)
            }
            
            
        }
        
    }
    
    @objc func handleSignUp(){
        self.navigationController?.pushViewController(RegistrationController(), animated: true)
        print("Tapped")
        //let navEditorViewController: UINavigationController = UINavigationController(rootViewController: RegistrationController())
       // self.present(navEditorViewController, animated: true, completion: nil)
    
    }
    
    
    // MARK : - Helpers
    
    func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                     paddingLeft: 40,
                                     paddingBottom: 15,
                                     paddingRight: 40)
    }
    
    
    
}

extension LoginController: UINavigationControllerDelegate {
    
}
