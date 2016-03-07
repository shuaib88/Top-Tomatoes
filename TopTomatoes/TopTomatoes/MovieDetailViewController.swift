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
    // add url and build in view did appear
    // add function that downloads image

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let title = movietitle {
            movieTitle.text = title
            movieImage.image = movieimage
        }
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
