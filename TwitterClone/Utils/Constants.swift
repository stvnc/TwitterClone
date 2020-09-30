//
//  Constants.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 23/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Firebase

let DB_Ref = Database.database().reference()
let REF_Users = DB_Ref.child("users")

let STORAGE_Ref = Storage.storage().reference()
let REF_Images = STORAGE_Ref.child("profile_image")

let REF_Tweets = DB_Ref.child("tweets")
let REF_User_Tweets = DB_Ref.child("user_tweets")
let REF_User_Followers = DB_Ref.child("user_followers")
let REF_User_Following = DB_Ref.child("user_following")
let REF_User_Replies = DB_Ref.child("user_replies")
let REF_User_Usernames = DB_Ref.child("user_usernames")

let REF_Tweet_Replies = DB_Ref.child("tweet_replies")
let REF_Tweet_Likes = DB_Ref.child("tweet_likes")

let REF_User_Likes = DB_Ref.child("user_likes")
let REF_Notifications = DB_Ref.child("notifications")
