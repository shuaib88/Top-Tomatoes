//
//  MovieTableViewCell.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 2/28/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var averageVote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
