//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 06/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .bio: return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    let user: User
    let option: EditProfileOptions
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
    
    var optionValue: String?{
        switch option{
            
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .bio:
            return user.bio
        }
    }
    
    var titleText: String{
        return option.description
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != nil
    }
    
}
