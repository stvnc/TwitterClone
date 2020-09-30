//
//  Utilities.swift
//  TwitterClone
//
//  Created by Vincent Angelo on 18/05/20.
//  Copyright © 2020 Vincent Angelo. All rights reserved.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        
        view.addSubview(iv)
        
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingBottom: 5)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom:  8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        return view
    }
    
    func textField(withPlaceHolder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    func attributedButton(withAttribute attribute: String, titleColor tColor: UIColor, backgroundColor bColor: UIColor) -> UIButton {
        let button = UIButton()
        button.backgroundColor = bColor
        button.setTitle(attribute, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(tColor, for: .normal)
        return button
    }
}
