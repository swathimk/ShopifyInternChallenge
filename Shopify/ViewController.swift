//
//  ViewController.swift
//  Shopify
//
//  Created by Swathi Bhattiprolu on 3/20/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

import UIKit
import MBProgressHUD

var shopifynetwork : ShopifyNetwork?

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MBProgressHUDDelegate {
    
    @IBOutlet var collectiontableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var hud: MBProgressHUD = MBProgressHUD()
    var selectedImage : UIImage!
    var collectionList = [Any]()
    var searchedCollectionList = [Any]()
    var isSearching = false
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 152/255.0, green: 191/255.0, blue: 67/255.0, alpha: 1.0)
        self.collectiontableView.tableHeaderView = self.searchBar
        shopifynetwork = ShopifyNetwork()
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading"
        hud.delegate = self
        self.hud.show(animated: true)
        shopifynetwork?.getCollectionsList(input: "test"){
            (result:Array) in
            self.collectionList = result
            self.searchedCollectionList = result
            self.collectiontableView.reloadData()
            self.hud.hide(animated: true)
        }
    }
    
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedCollectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : CollectionTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "collectioncell", for: indexPath) as? CollectionTableViewCell
        cell?.initiate()
        
        let dict = NSMutableDictionary(dictionary: (self.searchedCollectionList[indexPath.row] as! NSDictionary))
        
        cell?.title.text = (dict["title"] as! String)
        let url = dict["imageURL"] as! String
        cell?.getImage(url: url){
            (result:UIImage) in
            cell?.photo.image = result
            dict["image"] = result
            self.searchedCollectionList[indexPath.row] = dict as Any
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "CollectionDetails", sender: self)
    }
    
    // MARK: SearchBar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            self.searchedCollectionList = self.collectionList
            self.collectiontableView.reloadData()
        }
        else {
            isSearching = true
            self.searchedCollectionList = self.collectionList.filter{ (($0 as! NSDictionary)["title"] as? String)!.contains(searchBar.text!) }
            self.collectiontableView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DetailVC = segue.destination as! CollectionDetailViewController
        DetailVC.selectedCollection = self.searchedCollectionList[self.selectedIndex] as! NSDictionary
    }


}
