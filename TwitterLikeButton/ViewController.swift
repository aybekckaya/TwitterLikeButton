//
//  ViewController.swift
//  TwitterLikeButton
//
//  Created by aybek can kaya on 29.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewLike:LikeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addLikeView()
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap() {
        addLikeView()
    }
    
    
    func addLikeView() {
        viewLike?.removeFromSuperview()
        viewLike = nil
        
        viewLike = LikeView(frame: .zero)
        viewLike!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewLike!)
        viewLike!.backgroundColor = UIColor.clear
        
        viewLike!.addLengthConstraints(height: 36, width: 34)
        viewLike!.addAllignmentConstraints(centerX: 0, centerY: 0)
    }
}



extension UIView {
    
    func addAllignmentConstraints(centerX:CGFloat? , centerY:CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: centerX).isActive = true
        }
        if let centerY = centerY {
             NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: centerY).isActive = true
        }
        
    }
    
    
    func addLengthConstraints(height:CGFloat? , width:CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height).isActive = true
        }
        if let width = width {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width).isActive = true
        }
    }
    
    func addSnapConstraints(baseView:UIView , top:CGFloat? , bottom:CGFloat? , leading:CGFloat? , trailing:CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: top).isActive = true
        }
        if let bottom = bottom {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: bottom).isActive = true
        }
        if let leading = leading {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leading).isActive = true
        }
        if let trailing = trailing {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: trailing).isActive = true
        }
    }
    
    
}



extension Double {
    var degrees: Double {
        return self * (.pi) / 180.0
    }
    
    var radians: Double {
        return self * 180.0 / (.pi)
    }
}
