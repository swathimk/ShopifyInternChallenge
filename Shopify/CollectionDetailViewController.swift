//
//  CollectionDetailViewController.swift
//  Shopify
//
//  Created by Swathi Bhattiprolu on 3/21/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class CollectionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate {
    @IBOutlet var collectionImageView: UIImageView!
    @IBOutlet var collectionTitle: UILabel!
    @IBOutlet var collectionTitleM: UILabel!
    @IBOutlet var collectionDescription: UILabel!
    @IBOutlet var producttableView: UITableView!
    
    @IBOutlet var collectionCardHeight: NSLayoutConstraint!
    @IBOutlet var collectionImageHeight: NSLayoutConstraint!
    
    var hud: MBProgressHUD = MBProgressHUD()
    var productList = [Any]()
    
    var selectedCollection : NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 152/255.0, green: 191/255.0, blue: 67/255.0, alpha: 1.0)
        self.navigationController!.navigationItem.title = "Produts"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.navigationController!.navigationBar.titleTextAttributes = textAttributes
        self.title = "Products"
        
        self.collectionDescription.text = (selectedCollection["description"] as! String)
        self.collectionTitle.text = (selectedCollection["title"] as! String)
        self.collectionTitleM.text = (selectedCollection["title"] as! String)
        self.collectionImageView.image = (selectedCollection["image"] as! UIImage)
        
        initiateColletionImage()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading"
        hud.delegate = self
        
        shopifynetwork = ShopifyNetwork()
        self.hud.show(animated: true)
        shopifynetwork?.getCollectionDetailsList(collectionID: (selectedCollection["id"] as! String)){
            (result:Array) in
            self.productList = result
            self.producttableView.reloadData()
            self.hud.hide(animated: true)
        }
    }
    
    func initiateColletionImage(){
        
        if(self.collectionDescription.text == ""){
            self.collectionCardHeight.constant = 80
            self.collectionImageHeight.constant = 60
            self.collectionTitle.text = ""
        } else {
            self.collectionCardHeight.constant = 120
            self.collectionImageHeight.constant = 100
            self.collectionTitleM.text = ""
        }
        
        self.collectionImageView.layer.borderWidth = 1
        self.collectionImageView.layer.masksToBounds = false
        self.collectionImageView.layer.borderColor = UIColor.clear.cgColor
        self.collectionImageView.layer.cornerRadius = self.collectionImageHeight.constant/2
        self.collectionImageView.clipsToBounds = true
    }
    
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : CollectionDetailTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as? CollectionDetailTableViewCell
        cell?.initiate()
        
        let dict = (self.productList[indexPath.row] as! NSDictionary)
        
        cell?.title.text = (dict["title"] as! String)
        cell?.vendor.text = "Vendor : " + (dict["vendor"] as! String)
        cell?.body.text = (dict["description"] as! String)
        cell?.inventory.text = "Available Inventory : " + (dict["inventory"] as! String)
        let url = dict["imageURL"] as! String
        cell?.getImage(url: url){
            (result:UIImage) in
            cell?.photo.image = result
        }
        return cell!
    }
    
}
