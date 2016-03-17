//
//  FavoriteMovieViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 3/16/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class FavoriteMovieViewController: BaseTableViewController {
    
    // for accessing favorites
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = _activityIndicator {
        } else {
            self._activityIndicator = ActivityIndicatorView()
            self.view.addSubview(_activityIndicator!)
        }
        
        // get the favorite list stored from NSDefaults
    }

}
