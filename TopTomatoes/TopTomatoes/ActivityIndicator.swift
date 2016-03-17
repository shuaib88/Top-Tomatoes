//
//  ActivityIndicator.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 3/15/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//  
//  This activity indicator can be used anywhere to show a
//  Spinning blue activity indicator

import Foundation
import UIKit

class ActivityIndicatorView: UIView {
    
    // initialize the frame
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRectMake(0, 0, 100, 100))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // called anytime this is added to a superview
    override func didMoveToSuperview() {
        // check if superview exists
        guard (superview != nil) else {
            return
        }
        
        // and create what it looks like
        self.backgroundColor = UIColor.blueColor()
        self.layer.cornerRadius = 5
        
        self.center = self.superview!.center
        
        // add spinner to this
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.startAnimating()
        spinner.center.x = self.frame.size.width/2
        spinner.center.y = self.frame.size.height/2
        
        // add spinner to square
        self.addSubview(spinner)
    }
}