//
//  TabBarController.swift
//  TrendPlay
// 
//  Created by Chelsea Smith on 5/15/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit

let teamNavigationController = TeamNavigationController(nibName: nil, bundle: nil)

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = darkGreyColor
        //self.tabBar.barTintColor = navigationGreyColor
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = dashboardGreyColor.cgColor
        self.tabBar.clipsToBounds = false
        self.tabBar.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

}
