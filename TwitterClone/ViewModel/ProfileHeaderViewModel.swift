//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 29/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String{
        switch self{
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
    
}

// Create the view model
struct ProfileHeaderViewModel{
    private let user: User
    let usernameText: String
    
    var followerString: NSAttributedString?{
        return attributedText(withValue: user.stats?.followers ?? 0, text: " followers")
        
    }
    
    var followingString: NSAttributedString?{
        return attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }
    
    var actionButtonTitle: String {
        // If user is current user then set to edit profile
        // else figure out following/not following
        if user.isCurrentUser{
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }else{
            return "Following"
        }
        
    }
    
    init(user: User){
        self.user = user
        self.usernameText = "@\(user.username)"
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                                                  NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
