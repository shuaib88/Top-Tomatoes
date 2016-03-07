//
//  TMDBNetworkingManager.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 2/29/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import Foundation
import UIKit

class TMDBNetworkingManager {
    
    // instantiate the singleton
    static let sharedInstance = TMDBNetworkingManager()
    
    // prevent others from instantiating this
    private init() {}
    
    // func takes a url and a completion block  --> doesn't return anything accept
    // what's in the completion block
    func searchRequest(urlString: String, completion: ([String: AnyObject]?) -> Void) {
        
        /// - Attributions: http://www.ioscreator.com/tutorials/display-activity-indicator-status-bar-ios8-swift
        // start networking activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // convert string into an NSURL object
        guard let url = NSURL(string: urlString)
            else { fatalError("No URL") }
        
        // Create an 'NSURLSession' singleton Object
        let session = NSURLSession.sharedSession()
        
        // Create a task for the session object to complete takes a URL and completion block
        let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            
            // Guard against errors during download if exist -> populate the completion block as nil
            guard error == nil else {
                print("error: \(error!.localizedDescription): \(error!.userInfo)")
                completion (nil)
                return
            }
            
            // Print response header (for debugging)
            //            print(response)
            
            // Test if data has value else set to nil
            guard let data = data else {
                print("There was no data")
                completion(nil)
                return
            }
            
            // Unserialize the JSON into an Array of Dictionaries and
            // Pass as parameter to completion block
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                if let searchResponse = json as? [String: AnyObject] {
                    completion(searchResponse)
                }
            } catch {
                print("error serializing JSON: \(error)")
                completion(nil)
            }
            
            // turn off network activity
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        
        // Start the downloading. NSURLSession objects are created in the paused state, so to start it we need to tell it to resume
        task.resume()
    }

}
