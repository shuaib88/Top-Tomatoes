//
//  SplashScreenViewController.swift
//  TopTomatoes
//
//  Created by Shuaib Ahmed on 3/17/16.
//  Copyright © 2016 Shuaib Labs. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let splashView = UIView(frame: self.view.frame)
        splashView.backgroundColor = self.view.tintColor
        let devName = UILabel(frame: CGRectMake(0,0,200,100))
        devName.lineBreakMode = .ByWordWrapping
        devName.numberOfLines = 0
        devName.text = "Shuaib Ahmed \n Top Tomatoes"
        devName.textColor = UIColor.whiteColor()
        devName.center.x = self.view.center.x
        devName.center.y = self.view.center.y - 100
        devName.textAlignment = .Center
        splashView.addSubview(devName)
        
        let tomatoImage = UIImage(named: "tomato")
        let tomatoView = UIImageView(image: tomatoImage)
        tomatoView.center.x = self.view.center.x
        tomatoView.center.y = self.view.center.y - 50
        
        splashView.addSubview(tomatoView)
        
        self.view.addSubview(splashView)
        
    }
}
