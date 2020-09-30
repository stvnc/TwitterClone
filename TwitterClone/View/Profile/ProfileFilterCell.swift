//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 28/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // MARK: - Properties
    
    var option: ProfileFilterOptions! {
        didSet{
            titleLabel.text = option.description
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.text = "title"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override var isSelected: Bool{
        didSet{
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16):
            UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
