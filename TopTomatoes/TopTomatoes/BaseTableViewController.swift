//
//  BaseTableViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 2/28/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // properties
    // url to get the data
    let url = "https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2016-01-01&api_key=66a3c05ffe0ce8bbd8985c438c018a0a&primary_release_date.lte=2016-02-25&language=en"
    
    // this will hold my data from the API Call
    var movieResponse = [[String:AnyObject]]()
    
    // movie result
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
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
        
        let voteFloat = movieResult["vote_average"]! as? Float
        let voteAverage = String(format:"%.1f", voteFloat!)
        cell.averageVote.text = voteAverage
        
        // build image url
        let imageUrlStub = movieResult["poster_path"]! as? String
        let logoimageURL = "http://image.tmdb.org/t/p/w45" + imageUrlStub!
        
        // get image
        downloadImageWithClosure(logoimageURL, cell: cell)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// Segue function
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "show detail" {
            
            let movieDetailController = segue.destinationViewController as! MovieDetailViewController
            
//            if let movieDetailController = movieDetailController {
                // get the cell that generated the segue
                if let selectedMovieCell = sender as? MovieTableViewCell {
                    let indexPath = tableView.indexPathForCell(selectedMovieCell)!
                    let selectedMovie = movieResponse[indexPath.row]
                    
                    //populate the next view
                    movieDetailController.movietitle = selectedMovie["title"] as? String
                    movieDetailController.movieimage = selectedMovieCell.thumbImage.image
                    
//                    movieDetailController.movieTitle.text = "Poop"

                }
//            }
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