//
//  DecriptionViewController.swift
//  Abbot
//
//  Created by giovanni  tommasi on 07/12/2017.
//  Copyright © 2017 Giovanni  Tommasi. All rights reserved.
//

import UIKit
import WikipediaKit
import Alamofire

class DescriptionViewController: UIViewController {

    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Description: UITextView!
    
    let gradientLayer = CAGradientLayer()
    var id = ""
    var photo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors =  [UIColor(red: 80/255.5, green: 175/255.5, blue: 100/255.5, alpha: 1.0).cgColor , UIColor(red: 60/255.5, green: 180/255.5, blue: 150/255.5, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.Label.text = id
        self.Description.isEditable = false
        self.Description.isScrollEnabled = false
        
        WikipediaNetworking.appAuthorEmailForAPI = "Giovannitommasi95@gmail.com"
        
        let language = WikipediaLanguage("en")
        
        let _ = Wikipedia.shared.requestOptimizedSearchResults(language: language, term: id) { (searchResults, error) in
        
            for result in (searchResults?.results)!{
                if result.displayText != ""{
                    self.Description.text = result.displayText
                    break
                }
            }
        }
        
        let url = "http://192.168.1.111:8080/home/pi/Desktop.Abbot/pictures/"+id.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!+"1.jpg"
//        self.Image.image = #imageLiteral(resourceName: "default-image")
        
        if let saved = UserDefaults.standard.object(forKey: id) {
            self.Image.image = UIImage(data: saved as! Data)
        }
        else{
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(self.id)
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(url, to: destination).response { response in
                print(response)
                
                if response.error == nil, let imagePath = response.destinationURL?.path {
                    if let downloaded = UIImage(contentsOfFile: imagePath) {
                        self.photo.image = downloaded
                        UserDefaults.standard.set(UIImageJPEGRepresentation(downloaded, 0.2)! as NSData, forKey: self.id)
                    }
                }
            }
        }
    }
        
    override func viewDidLayoutSubviews() {
        gradientLayer.frame = self.view.bounds
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
