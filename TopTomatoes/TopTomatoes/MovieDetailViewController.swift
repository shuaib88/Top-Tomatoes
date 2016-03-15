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
    
    // add url and build in view did appear
    // add function that downloads image

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let title = movietitle {
            movieTitle.text = title
            movieImage.image = movieimage
            print(imageUrl)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        // call downloadwithclosure
        downloadImageWithClosure(imageUrl!)
     }
    
    func downloadImageWithClosure(url: String) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let nsUrl = NSURL(string: url)
        
        // Make the download call
        downloadImage(nsUrl!) { (downloadedImage) -> () in
            // Ensure the completion block is on the main thread
            sleep(3)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
