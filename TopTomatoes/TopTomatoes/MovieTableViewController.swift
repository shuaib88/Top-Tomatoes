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
    
    /// Segue function
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let movieDetailController = segue.destinationViewController as! MovieDetailinScrollViewController
        
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
}