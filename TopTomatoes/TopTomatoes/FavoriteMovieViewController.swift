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
        // check if favorites array exists, if not -- add it
        if let favArray = defaults.objectForKey("favoritesArray") as! [[String:AnyObject]]? {
            movieResponse = favArray

            self.tableView.reloadData()
            
        } else {
            // initializes defaults with an empty array of strings
            defaults.setObject(favoritesArray, forKey: "favoritesArray")
        }
        
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
//        
//        let movieResult = movieResponse[indexPath.row]
//        
//        cell.movieTitle.text = movieResult["title"]! as? String
//        
//        let voteFloat = movieResult["vote_average"]! as? Float
//        let voteAverage = String(format:"%.1f", voteFloat!)
//        cell.averageVote.text = "Rating: " + voteAverage
////        cell.averageVote.text = "Rating: " + "10.00"
//        
//        // build image url
//        
//        var imageUrlStub = movieResult["poster_path"]! as? String
//        
//        if imageUrlStub == nil {
//            imageUrlStub = ""
//        }
//        
//        let logoimageURL = "http://image.tmdb.org/t/p/w45" + imageUrlStub!
//        
//        // get image
//        downloadImageWithClosure(logoimageURL, cell: cell)
//        
//        // stylize the font
//        cell.movieTitle.font = UIFont (name: "HelveticaNeue", size: 17)
//        cell.averageVote.font = UIFont (name: "HelveticaNeue", size: 17)
//        
//        return cell
//    }


}
