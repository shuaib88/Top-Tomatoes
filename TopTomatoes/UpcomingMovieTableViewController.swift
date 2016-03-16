//
//  UpcomingMovieTableViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 3/16/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class UpcomingMovieTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // set the url
        url = "https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2016-03-16&primary_release_date.lte=2016-04-16&api_key=66a3c05ffe0ce8bbd8985c438c018a0a&language=en"
    }
}
