//
//  ShopifyNetwork.swift
//  Shopify
//
//  Created by Swathi Bhattiprolu on 3/20/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ShopifyNetwork: UIViewController {
    
    var collectionList = [Any]()
    var productList = [Any]()
    var productString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }


    func getCollectionsList(input: String, completion: @escaping (_ result: Array<Any>) -> Void) {
    
        let url = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let collectionCount = json["custom_collections"].count
                for i in 0...collectionCount-1
                {   
                    var collection = [String:String]()
                    
                    collection["id"] = (json["custom_collections"][i]["id"]).stringValue
                    collection["title"] = (json["custom_collections"][i]["title"]).stringValue
                    collection["description"] = (json["custom_collections"][i]["body_html"]).stringValue
                    collection["imageURL"] = (json["custom_collections"][i]["image"]["src"]).stringValue
                    
                    self.collectionList.append(collection)
    
                }
                
            case .failure(let error):
                print(error)
            }
        
        completion(self.collectionList)
        }
    
    }
    
    
    func getCollectionDetailsList(collectionID: String, completion: @escaping (_ result: Array<Any>) -> Void) {
        
        let collectionurl = "https://shopicruit.myshopify.com/admin/collects.json?collection_id=" + collectionID + "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            group.enter()
            
            Alamofire.request(collectionurl, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let collectionCount = json["collects"].count
                    for i in 0...collectionCount-1
                    {
                        self.productString += (json["collects"][i]["product_id"]).stringValue + ","
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
                group.leave()
            }
            
            group.wait()
            
            let producturl = "https://shopicruit.myshopify.com/admin/products.json?ids=" + self.productString + "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
            
            Alamofire.request(producturl,method: .get).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let productsCount = json["products"].count
                    for i in 0...productsCount-1
                    {
                        var product = [String:String]()
                        
                        product["title"] = (json["products"][i]["title"]).stringValue
                        product["vendor"] = (json["products"][i]["vendor"]).stringValue
                        product["description"] = (json["products"][i]["body_html"]).stringValue
                        product["imageURL"] = (json["products"][i]["image"]["src"]).stringValue
                        
                        let variants = (json["products"][i]["variants"]).arrayValue
                        var inventory = 0
                        
                        for j in 0...variants.count-1{
                            inventory += (variants[j]["inventory_quantity"]).intValue
                        }
                        
                        product["inventory"] = String(inventory)
                        self.productList.append(product)
                    }
                    
                case .failure(let error):
                    print(error)
                }
                
                completion(self.productList)
            }
        }
        
    }
    
    
    

}
