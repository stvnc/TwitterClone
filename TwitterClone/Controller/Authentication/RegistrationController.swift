//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 18/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit
import Firebase


class RegistrationController: UIViewController {
    
    var profileImage : UIImage? = UIImage(named: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(withAttribute: "Already have an account? Sign In", titleColor: .white, backgroundColor: .twitterBlue)
        button.addTarget(self, action: #selector(handleAlrGotAccount), for: .touchUpInside)
        return button
        
    }()
    
    private let imagePicker = UIImagePickerController()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"),for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleImagePicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "mail")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
        
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextField)
        return view
        
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
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
    
    private let fullnameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Fullname")
        return tf
    }()
    
    private let usernameTextField: UITextField =  {
        let tf = Utilities().textField(withPlaceHolder: "Username")
        return tf
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlrGotAccount() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleRegister(){
        
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image")
            return
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow})  else { return}
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.authenticateUserAndConfigureUI()
            print("DEBUG: Sign Up Successful")
            print("DEBUG: Handle Update User Interface Here")
            self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
        }
        
        print("DEBUG: Email is \(email)")
        print("DEBUG: Password is \(password)")
        print("DEBUG: Fullname is \(fullname)")
        print("DEBUG: Username is \(username)")
    }
    
    func configureUI(){
        
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(registerButton)
        registerButton.anchor(top: stack.bottomAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 30, paddingLeft: 50, paddingRight: 50)
        registerButton.setDimensions(width: 50, height: 50)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 15, paddingRight: 40)
    }
    
    @objc func handleImagePicker(){
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
}

// Protocol for delegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        profileImage = info[.editedImage] as? UIImage
        
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
