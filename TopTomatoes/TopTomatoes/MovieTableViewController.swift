//
//  BaseTableViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 2/28/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class MovieTableViewController: BaseTableViewController {
    
    // movie result
    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = "https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2016-01-01&api_key=66a3c05ffe0ce8bbd8985c438c018a0a&primary_release_date.lte=2016-02-25&language=en"

    }
}