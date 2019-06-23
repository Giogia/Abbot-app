//
//  LabelsTableViewController.swift
//  Abbot
//
//  Created by giovanni  tommasi on 08/12/2017.
//  Copyright © 2017 Giovanni  Tommasi. All rights reserved.
//

import UIKit
import Alamofire

class LabelsTableViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    let gradientLayer = CAGradientLayer()
    
    var id = ""
    var photo = UIImageView()
    var keywords = [String]()
    
    @IBOutlet weak var labelsTableView: UITableView!
    @IBOutlet weak var Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let db = appDelegate.db
        let labelsTable = appDelegate.labelsTable
        let labelRow = appDelegate.labelRow
        let photoRow = appDelegate.photoRow
        
        //set delegate and datasource for collectionview
        self.labelsTableView.delegate = self
        self.labelsTableView.dataSource = self
        
        //set gradient background
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors =  [UIColor(red: 80/255.5, green: 175/255.5, blue: 100/255.5, alpha: 1.0).cgColor , UIColor(red: 60/255.5, green: 180/255.5, blue: 150/255.5, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.Image.image = photo.image
        
        //set collection cell's names
        for query in try! db.prepare(labelsTable){
            if query[photoRow]==id {
                keywords.append(query[labelRow])
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = labelsTableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! TableViewCell
        
        cell.Label.text = keywords[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tableView.cellForRow(at: indexPath) as! TableViewCell
        id = row.Label.text!
        performSegue(withIdentifier: "ShowDescription", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! DescriptionViewController
        destinationViewController.id = id
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
