//
//  MovieDetailViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 3/6/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var plotSummary: UILabel!
    
    var movietitle: String?
    var movieimage: UIImage?
    var imageUrl: String?
    var plotOverview: String?
    var voteAverage: String?
    var posterPath: String?
    
    // activity indicator
    var _activityIndicator: ActivityIndicatorView?
    
    // star images
    let filledStar: UIImage = UIImage(named: "star")!
    let unfilledStar: UIImage = UIImage(named: "unfilledStar")!
    
    // for storing favorites
    let defaults = NSUserDefaults.standardUserDefaults()
    var favoritesArray = [[String:AnyObject]]()
    var passedDetailItem = [String:AnyObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let title = movietitle {
            movieTitle.text = title
            movieImage.image = movieimage
            print(imageUrl)
            plotSummary.text = plotOverview
        }
        
        // check if favorites array exists, if not -- add it
        if let favArray = defaults.objectForKey("favoritesArray") as! [[String:AnyObject]]? {
                favoritesArray = favArray
        } else {
            // initializes defaults with an empty array of strings
            defaults.setObject(favoritesArray, forKey: "favoritesArray")
        }
        
        // check if current item is in favorites
        if isCurrentMovieInFavorites() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: filledStar, style: .Plain, target: self, action: "addFavorite")
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: unfilledStar, style: .Plain, target: self, action: "addFavorite")
        }
        // add bar button
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = _activityIndicator {
        } else {
            self._activityIndicator = ActivityIndicatorView()
            self.view.addSubview(_activityIndicator!)
        }
        print("large image url: \(imageUrl)")
        // call downloadwithclosure
        downloadImageWithClosure(imageUrl!)
     }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self._activityIndicator!.removeFromSuperview()
    }
    
    // downloads image using an api call
    func downloadImageWithClosure(url: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let nsUrl = NSURL(string: url)
        
        // Make the download call
        downloadImage(nsUrl!) { (downloadedImage) -> () in
            // Ensure the completion block is on the main thread
            sleep(1)
            self.movieImage.image = downloadedImage
            print("Elaspsed Time: " + (NSString(format: "%2.5f", CFAbsoluteTimeGetCurrent() - startTime) as String))
        }
    }
    // helper function that actually opens an NSURL session
    func downloadImage(url: NSURL, completion: (UIImage)->()) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // Check that there was no data; this is misleading since a 404 does not
            // return an error.  Note: All paramters in the completion handler are optionals
            guard error == nil else {
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                return
            }
            
            guard response != nil else {
                // Check the response
                print("Response: \(response)")
                return
            }
            
            guard let taskData: NSData = data where data != nil else {
                print("Error with data")
                return
            }
            
            // Create a UIImage from the response data and pass it to the completion
            // handler
            //print(taskData)
            if let image = UIImage(data: taskData) {
                print("Done downloading")
                dispatch_async(dispatch_get_main_queue()) {
                    completion(image)
                }
            }
        })
        
        // Tasks start in the suspended state, so resume it to start immediately
        task.resume()
    }
    
    // This method managers the favorite star showing + updating what is stored in the favorites array
    func addFavorite() {
        
        print("addFavorites button pressed")
        
        // update star
        if navigationItem.rightBarButtonItem?.image == unfilledStar {
            navigationItem.rightBarButtonItem!.image = filledStar
        } else {
            navigationItem.rightBarButtonItem!.image = unfilledStar
        }
        
        // create detailItem object
//        var detailItem = [String:String]()
//        detailItem["title"] = movietitle
//        detailItem["vote_average"] = voteAverage
//        detailItem["poster_path"] = posterPath
//        detailItem["overview"] = plotOverview
        
        // add or remove in favorites
        if isCurrentMovieInFavorites() {
            print("removing from favorites")
            // remove from favorites
            favoritesArray.removeAtIndex(favMovieIndex())

        } else {
            print("adding to favorites")
            // add to favorites
            favoritesArray.append(passedDetailItem)
        }
        
        // re-add the array to nsuserdefaults
        defaults.setObject(favoritesArray, forKey: "favoritesArray")
        
        print(favoritesArray.count)
    }
    
    // checks if movie on the page is in the favorites array
    func isCurrentMovieInFavorites() -> Bool {
        
        var bool = false
        
        let favoritesArray = defaults.valueForKey("favoritesArray") as! [[String:AnyObject]]
        
        if favoritesArray.count == 0 {
            bool = false
        }

        for savedFavorite in favoritesArray {
            if savedFavorite["title"] as? String == movietitle {
                bool = true
            } else {
                bool = false
            }
        }
        
        return bool
    }

    // finds index of movie in favorites array assuming it exists - only call if isCurrentMovieInFavorites is true
    func favMovieIndex() -> Int {
        
        var count = 1000
        
        let favoritesArray = defaults.valueForKey("favoritesArray") as! [[String:AnyObject]]
        
        for savedFavorite in favoritesArray {
            count = 0
            if savedFavorite["title"] as? String != movietitle {
                count += 1
            } else {
                break
            }
        }
        
        return count
    }
}
