//
//  ConversationsController.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 17/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class ConversationsController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK : - Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        navigationItem.title = "messages"
        
    }
}
