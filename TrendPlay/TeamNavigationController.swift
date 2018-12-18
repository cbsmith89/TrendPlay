//
//  TeamNavigationController.swift
//  TrendPlay
// 
//  Created by Chelsea Smith on 5/15/17.
//  Copyright © 2017 Trending Productions LLC. All rights reserved.
//

import UIKit

class TeamNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = darkGreyColor
        self.navigationBar.barTintColor = navigationGreyColor
        /*self.navigationBar.layer.borderWidth = 0.5
        self.navigationBar.layer.borderColor = navigationSeparatorGreyColor.cgColor*/
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = dashboardGreyColor.cgColor
        self.navigationBar.layer.shadowOpacity = 1.0
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationBar.layer.shadowRadius = 3.0
        self.navigationBar.topItem?.title = " "
     }
    
    func changeImagePosition(image: UIImage, origin: CGPoint) -> UIImage {
        let size = image.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 5)
        image.draw(in: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /*var backButtonImage = UIImage(named: "backButtonImage")!
    backButtonImage = changeImagePosition(backButtonImage, origin: CGPointMake(0, 0))
    
    navigationController!.navigationBar.backIndicatorImage = backButtonImage
    navigationController!.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    ...
    func changeImagePosition(image: UIImage, origin: CGPoint) -> UIImage {
        let size = image.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        image.drawInRect(CGRectMake(origin.x, origin.y, size.width, size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = darkGreyColor
        self.navigationBar.barTintColor = navigationGreyColor
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = dashboardGreyColor.cgColor
        self.navigationBar.layer.shadowOpacity = 0.8
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationBar.layer.shadowRadius = 3.0
        self.navigationBar.isTranslucent = false
        self.navigationBar.isHidden = true
        self.navigationController?.toolbar.isHidden = true
        self.setToolbarHidden(true, animated: false)
        self.extendedLayoutIncludesOpaqueBars = true
        super.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = darkGreyColor
        self.navigationBar.barTintColor = navigationGreyColor
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = dashboardGreyColor.cgColor
        self.navigationBar.layer.shadowOpacity = 0.8
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationBar.layer.shadowRadius = 3.0
        self.navigationBar.isTranslucent = false
        self.navigationBar.isHidden = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.toolbar.isHidden = true
        super.tabBarController?.tabBar.isHidden = false
    }
}
