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
    var favoritesArray = [[String:AnyObject]]()

//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
    
    override func viewWillAppear(animated: Bool) {
        if let _ = _activityIndicator {
        } else {
            self._activityIndicator = ActivityIndicatorView()
            self.view.addSubview(_activityIndicator!)
        }
        
        // get the favorite list stored from NSDefaults
        // check if favorites array exists, if not -- add it
        if let favArray = defaults.objectForKey("favoritesArray") as! [[String:AnyObject]]? {
            movieResponse = favArray
            self.tableView.reloadData()
        } else {
            // initializes defaults with an empty array of strings
            defaults.setObject(favoritesArray, forKey: "favoritesArray")
        }
    }
}
