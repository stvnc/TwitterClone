//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 17/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit
import Firebase

enum ActionButtonConfiguration{
    case tweet
    case message
}

class MainTabController: UITabBarController {
    
    var user: User?{
        didSet{
            print("DEBUG: USER SIGNED IN!")
            guard let nav  = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    // MARK : - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .tweet
    
    let actionButton: UIButton =  {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK : - API
    
    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            print("DEBUG: USER \(user.username) LOGGED IN")
            self.user = user
        }    }
    
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async{
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            }
        }else{
            fetchUser()
            configureUI()
            configureViewControllers()
        }
        print("DEBUG: User is not logged in")
        
    }
    
    // MARK : - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK : - Selectors
    
    
    @objc func actionButtonTapped(){
        
        let controller: UIViewController
        
        switch buttonConfig {
            
        case .tweet:
            guard let user = user else { return }
            controller = UploadTweetController(user: user, config: .tweet)
        case .message:
            controller = SearchController(config: .messages)
        }
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
    }
    
    //MARK : - Helpers
    
    func configureUI(){
        self.delegate = self
        
        view.addSubview(actionButton)
        // Auto Layout
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 100, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56/2
        
        
    }
    
    func configureViewControllers(){
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feed_nav = templateNavigationController(image: UIImage(named: "home_unselected")!, rootViewController: feed)
        
        let explore = SearchController(config: .userSearch)
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        let explore_nav = templateNavigationController(image: UIImage(named: "search_unselected")!, rootViewController: explore)
        
        let notifications = NotificationsController()
        notifications.tabBarItem.image = UIImage(named: "home_unselected")
        let notifications_nav = templateNavigationController(image: UIImage(named: "like_unselected")!, rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversations_nav =  templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1")!, rootViewController: conversations)
        
        viewControllers = [feed_nav, explore_nav, notifications_nav, conversations_nav]
    }
    
    func templateNavigationController(image : UIImage, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.tintColor = .white
        return nav
        
        
    }
    
    
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        
        let image = index == 3 ? #imageLiteral(resourceName: "mail") : #imageLiteral(resourceName: "new_tweet")
        actionButton.setImage(image, for: .normal)
        buttonConfig = index == 3 ? .message : .tweet
    }
}
