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
    
    // activity indicator
    var _activityIndicator: ActivityIndicatorView?
    
    // star images
    let filledStar: UIImage = UIImage(named: "star")!
    let unfilledStar: UIImage = UIImage(named: "unfilledStar")!
    
    // add url and build in view did appear
    // add function that downloads image

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let title = movietitle {
            movieTitle.text = title
            movieImage.image = movieimage
            print(imageUrl)
            plotSummary.text = plotOverview
        }
        
        // add bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: unfilledStar, style: .Plain, target: self, action: "addFavorite")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ = _activityIndicator {
        } else {
            self._activityIndicator = ActivityIndicatorView()
            self.view.addSubview(_activityIndicator!)
        }
        
        // call downloadwithclosure
        downloadImageWithClosure(imageUrl!)
     }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self._activityIndicator!.removeFromSuperview()
    }
    
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
    
    func addFavorite() {
        // make sure favorite star appears
        if navigationItem.rightBarButtonItem?.image == unfilledStar {
            navigationItem.rightBarButtonItem!.image = filledStar
        } else {
            navigationItem.rightBarButtonItem!.image = unfilledStar
        }
    }
}
