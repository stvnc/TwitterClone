//
//  TweetService.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 26/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["uid" : uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        switch type{
        case .tweet:
            let ref = REF_Tweets.childByAutoId()
            
            ref.updateChildValues(values) { (err, ref) in
                guard let tweetID = ref.key else { return }
                REF_User_Tweets.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
            
        case .reply(let tweet):
            values["replyingTo"] = tweet.user.username
            REF_Tweet_Replies.child(tweet.tweetID).childByAutoId().updateChildValues(values) { (err, ref) in
                guard let replyKey = ref.key else { return }
                    REF_User_Replies.child(uid).updateChildValues([tweet.tweetID: replyKey], withCompletionBlock: completion)
                
            }
        }
        
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_User_Following.child(currentUid).observe(.childAdded) { snapshot in
            let followingUid = snapshot.key
            
            REF_User_Tweets.child(followingUid).observe(.childAdded) { snapshot in
                let tweetID = snapshot.key
                
                self.fetchTweet(withTweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
            
            
        } 
        
        REF_User_Tweets.child(currentUid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
//        REF_Tweets.observe(.childAdded) { (snapshot) in
//            print("DEBUG: Snapshot \(snapshot.value)")
//            guard let dictionary = snapshot.value as? [String:Any] else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            let tweetID = snapshot.key
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
//
//                tweets.append(tweet)
//                completion(tweets)
//            }
//
//
//
//        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        REF_User_Tweets.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchTweet(withTweetID: tweetID) { tweet in

                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet)-> Void) {
        REF_Tweets.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchReplies(forUser user: User, completion: @escaping([Tweet]) ->  Void) {
        var replies = [Tweet]()
        
        REF_User_Replies.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            
            print("DEBUG: TweetKey = \(tweetKey)")
            print("DEBUG: ReplyKey = \(replyKey)")
            
            REF_Tweet_Replies.child(tweetKey).child(replyKey).observe(.value) { snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(tweet)
                    completion(replies)
                }
            }
            
            
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        REF_Tweet_Replies.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        REF_User_Likes.child(user.uid).observe(.childAdded) { snapshot in
            
            let tweetID = snapshot.key
            self.fetchTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_Tweets.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike {
            
            REF_User_Likes.child(uid).child(tweet.tweetID).removeValue { (err, ref) in
                REF_Tweet_Likes.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
            
        } else {
            REF_User_Likes.child(uid).updateChildValues([tweet.tweetID: 1]) { (err, ref) in
                REF_Tweet_Likes.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_User_Likes.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
