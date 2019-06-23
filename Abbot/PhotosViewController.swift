//
//  PhotosViewController.swift
//  Abbot
//
//  Created by giovanni  tommasi on 02/12/2017.
//  Copyright © 2017 Giovanni  Tommasi. All rights reserved.
//

import UIKit
import Alamofire

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var names = [String]()
    var images = ["a","b","c"]
    var labels = [String]()
    
    let gradientLayer = CAGradientLayer()
    
    var id = ""
    var photo = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let db = appDelegate.db
        let photosTable = appDelegate.photosTable
        let photoRow = appDelegate.photoRow
        let checked = appDelegate.checked
        
        //set delegate and datasource for collectionview
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self
        
        //set gradient background
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors =  [UIColor(red: 80/255.5, green: 175/255.5, blue: 100/255.5, alpha: 1.0).cgColor , UIColor(red: 60/255.5, green: 180/255.5, blue: 150/255.5, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        //set collection cell's names
        for query in try! db.prepare(photosTable){
            if query[checked]==true {
                names.append(query[photoRow])
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        let url = "http://192.168.1.111:8080/home/pi/Desktop/Abbot/resources/"+names[indexPath.row].addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//        UserDefaults.standard.set(UIImageJPEGRepresentation(#imageLiteral(resourceName: "default-image"), 0.2)! as NSData, forKey: self.names[indexPath.row])
        cell.Image.image = #imageLiteral(resourceName: "default-image")
        
        if let saved = UserDefaults.standard.object(forKey: self.names[indexPath.row]) {
            cell.Image.image = UIImage(data: saved as! Data)
        }
        else{
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(self.names[indexPath.row])
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(url, to: destination).response { response in
                print(response)
                
                if response.error == nil, let imagePath = response.destinationURL?.path {
                    if let downloaded = UIImage(contentsOfFile: imagePath) {
                        cell.Image.image = downloaded
                        UserDefaults.standard.set(UIImageJPEGRepresentation(downloaded, 0.2)! as NSData, forKey: self.names[indexPath.row])
                    }
                }
            }
        }
        cell.Image.layer.masksToBounds = true
        cell.Image.layer.cornerRadius = cell.Image.frame.height/2
        cell.Label.text = names[indexPath.row]
        cell.Keywords = labels
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        id = cell.Label.text!
        photo.image = cell.Image.image!
        performSegue(withIdentifier: "ShowLabels", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! LabelsTableViewController
        destinationViewController.id = id
        destinationViewController.photo = photo
        
    }
}

