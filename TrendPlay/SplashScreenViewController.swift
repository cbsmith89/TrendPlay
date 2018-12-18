//
//  SplashScreenViewController.swift
//  TrendPlay
// 
//  Created by Chelsea Smith on 9/15/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var splashLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 21/255, green: 21/255, blue: 21/255, alpha: 1.0) //darkGreyColor
        splashLogo.frame = CGRect(x: 0, y: 0, width: 125, height: 115)
        splashLogo.center = self.view.center
        splashLogo.contentMode = .scaleAspectFit
        activityIndicatorView.frame = CGRect(x: splashLogo.center.x - 15, y: splashLogo.frame.maxY + 25, width: 30, height: 30)
        activityIndicatorView.contentMode = .scaleAspectFit
        activityIndicatorView.color = orangeColor
        activityIndicatorView._setTypeName("ballTrianglePath")
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        Timer.scheduledTimer(timeInterval: 2.25, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "homeViewControllerSegue", sender: self)
    }

}
