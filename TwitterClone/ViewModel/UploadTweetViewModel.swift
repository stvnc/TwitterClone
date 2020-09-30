//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 03/06/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration{
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    
    init(config: UploadTweetConfiguration){
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            replyText = "Replying to @\(tweet.user.username)"
            shouldShowReplyLabel = true        }
    }
}
