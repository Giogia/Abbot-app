//
//  InitialViewController.swift
//  Abbot
//
//  Created by giovanni  tommasi on 10/12/2017.
//  Copyright © 2017 Giovanni  Tommasi. All rights reserved.
//

import UIKit
import SQLite
import Alamofire

class InitialViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var imageview: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func connect(_ sender: Any) {
        
        let url = "http://192.168.1.111:8080/home/pi/Desktop/Abbot/Abbot.db"
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("Abbot.db")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(url, to: destination).response { response in
            print(response)
            
            if response.error == nil, let databasePath = response.destinationURL?.path {
                self.appDelegate.db = try! Connection(databasePath)
                self.performSegue(withIdentifier: "ShowApp", sender: self)
            }
        }
    }

}
