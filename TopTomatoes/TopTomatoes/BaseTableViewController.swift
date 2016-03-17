//
//  BaseTableViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 3/16/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation

import UIKit

class BaseTableViewController: UITableViewController {
    
    // properties
    // url to get the data
    var url = ""
    
    // this will hold my data from the API Call
    var movieResponse = [[String:AnyObject]]()
    
    var _activityIndicator: ActivityIndicatorView?
    
    // get initial data
    override func viewWillAppear(animated: Bool) {
        
        if let _ = _activityIndicator {
        } else {
            self._activityIndicator = ActivityIndicatorView()
            self.view.addSubview(_activityIndicator!)
        }
        
        TMDBNetworkingManager.sharedInstance.searchRequest(url) { (response) -> Void in
            
            // Test that response is not nil and unwrap
            // if nil then return so prevent reloading table unecesarily.
            guard let response = response else {
                self.makeAlertForNetworkError()
                return
            }
            
            // Set the response data to the view controller's 'movieResponse' property
            let apiCallResponse = response
            self.movieResponse = apiCallResponse["results"]! as! [[String:AnyObject]]
            
            // force a reload data on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // remove activity indicator
//        sleep(1)
        self._activityIndicator!.removeFromSuperview()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // returns number of rows
        return self.movieResponse.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return CGFloat(70)
    }
    
    func downloadImageWithClosure(url: String, cell: MovieTableViewCell) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let nsUrl = NSURL(string: url)
        
        // Make the download call
        downloadImage(nsUrl!) { (downloadedImage) -> () in
            // Ensure the completion block is on the main thread
            cell.thumbImage.image = downloadedImage
            print("Elaspsed Time: " + (NSString(format: "%2.5f", CFAbsoluteTimeGetCurrent() - startTime) as String))
        }
    }
    
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        let movieResult = movieResponse[indexPath.row]
        
        cell.movieTitle.text = movieResult["title"]! as? String
        
        print(movieResult["vote_average"]!.dynamicType)
        let voteFloat = movieResult["vote_average"]! as? Float
        let voteAverage = String(format:"%.1f", voteFloat!)
        cell.averageVote.text = "Rating: " + voteAverage
        
        // build image url
        
        var imageUrlStub = movieResult["poster_path"]! as? String
        
        if imageUrlStub == nil {
            imageUrlStub = ""
        }
        
        let logoimageURL = "http://image.tmdb.org/t/p/w45" + imageUrlStub!
        
        // get image
        downloadImageWithClosure(logoimageURL, cell: cell)
        
        // stylize the font
        cell.movieTitle.font = UIFont (name: "HelveticaNeue", size: 17)
        cell.averageVote.font = UIFont (name: "HelveticaNeue", size: 17)
        
        return cell
    }
    
    /// Segue function
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let movieDetailController = segue.destinationViewController as! MovieDetailViewController
        
        // get the cell that generated the segue
        if let selectedMovieCell = sender as? MovieTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedMovieCell)!
            let selectedMovie = movieResponse[indexPath.row]
            
            
            // build the url string
            var imageUrlStub = selectedMovie["poster_path"]! as? String
            
            if imageUrlStub == nil {
                imageUrlStub = ""
            }
            
            let logoimageURL = "http://image.tmdb.org/t/p/w185" + imageUrlStub!
            
            //populate the next view
            movieDetailController.movietitle = selectedMovie["title"] as? String
            movieDetailController.movieimage = selectedMovieCell.thumbImage.image
            movieDetailController.imageUrl = logoimageURL
            movieDetailController.plotOverview = selectedMovie["overview"] as? String
            movieDetailController.voteAverage = selectedMovie["vote_average"] as? String
            movieDetailController.posterPath = selectedMovie["poster_path"] as? String
            
            movieDetailController.passedDetailItem = selectedMovie as [String:AnyObject]
        }
    }
    
    /// Helper functions
    /// creates an alertview for network errors
    func makeAlertForNetworkError() -> Void {
        let alertController = UIAlertController(title: "Network Error", message: "Get some Internets, Fool 👻👻👻", preferredStyle: .ActionSheet)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            return
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            return
        }
    }
    
    
    
}