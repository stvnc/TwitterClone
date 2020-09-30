//
//  Users.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 24/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation
import Firebase

struct User{
    let email: String
    var fullname: String
    var username: String
    var profileImageURL: URL?
    let uid: String
    var stats: UserRelationStats?
    var isFollowed = false
    var bio: String?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    init(uid: String, dictionary: [String:AnyObject]){
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
        
        if let profileImageURLString = dictionary["profileImageURL"] as? String {
            guard let url = URL(string: profileImageURLString) else {return}
            self.profileImageURL = url
        }
        
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
    
}
