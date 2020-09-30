//
//  AuthService.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 23/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//
import UIKit
import Firebase

struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUser(withEmail email: String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void){
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        let profileImage = credentials.profileImage
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {return}
        let fileName = NSUUID().uuidString
        let storageRef = REF_Images.child(fileName)
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {return}
            storageRef.putData(imageData, metadata: nil) { (metaData, error) in
                storageRef.downloadURL { (url, error) in
                    guard let profileImageURL = url?.absoluteString else {return}
                    
                    let values = ["email": email, "fullname": fullname, "username": username, "profileImageURL": profileImageURL]
                    
                    REF_Users.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    
    func logUserOut(){
        do{
            try Auth.auth().signOut()
        } catch let error{
            print("DEBUG: Failed to sign user out, \(error.localizedDescription)")
        }
    }
}

