//
//  TabBarViewController.swift
//  Abbot
//
//  Created by giovanni  tommasi on 07/12/2017.
//  Copyright © 2017 Giovanni  Tommasi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.barTintColor = UIColor(red: 230/255.5, green: 255/255.5, blue: 230/255.5, alpha: 0.3)
        self.tabBar.tintColor = UIColor(red:60/255.5, green:180/255.5, blue:150/255.5, alpha: 1.0)
        self.tabBar.isTranslucent = true
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Arial", size: 32) ?? "default"], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
