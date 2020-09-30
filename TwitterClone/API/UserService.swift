//
//  UserService.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 23/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService{
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User)-> Void){
        print("DEBUG: UID \(uid)")
        REF_Users.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            print("DEBUG: Snapshot \(snapshot)")
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            print("DEBUG: Dictionary \(dictionary)")
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User])-> Void) {
        var users = [User]()
        REF_Users.observe(.childAdded)  { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_User_Following.child(currentUid).updateChildValues([uid:1]) { (err, ref) in
            REF_User_Followers.child(uid).updateChildValues([currentUid:1], withCompletionBlock: completion)
        }
        
        print("DEBUG: Current UID: \(currentUid) started following \(uid)")
        print("DEBUG: UID \(currentUid) gained \(currentUid) as a follower")
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_User_Following.child(currentUid).child(uid).removeValue { (err, ref) in
            REF_User_Followers.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
        
    }
    
    func checkIfUsersIsFollowed(uid: String, completion: @escaping(Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_User_Following.child(currentUid).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
    }
    
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void){
        REF_User_Followers.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            REF_User_Following.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)

            }
            
            print("DEBUG: Followers count : \(followers)")
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = STORAGE_Ref.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, err) in
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageURL": profileImageUrl]
                REF_Users.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["fullname": user.fullname,
                      "username": user.username,
                      "bio": user.bio ?? ""]
        
        REF_Users.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void){
        REF_User_Usernames.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let uid = snapshot.value as? String else { return }
            self.fetchUser(uid: uid, completion: completion)
        }
    }
}
