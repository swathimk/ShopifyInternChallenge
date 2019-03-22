//
//  CollectionTableViewCell.swift
//  Shopify
//
//  Created by Swathi Bhattiprolu on 3/20/19.
//  Copyright © 2019 Swathi Bhattiprolu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class CollectionTableViewCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var photo: UIImageView!
    
    var collectionImage : UIImage!
    
    func initiate(){
        photo.layer.borderWidth = 1
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.clear.cgColor
        photo.layer.cornerRadius = photo.frame.height/2
        photo.clipsToBounds = true
    }
    
    func getImage(url: String, completion: @escaping (_ result: UIImage) -> Void) {
        Alamofire.request(url, method: .get).responseData { response in
            switch response.result {
            case .success(let value):
                self.collectionImage = UIImage(data:value)
            case .failure(let error):
                print(error)
            }
            completion(self.collectionImage)
        }
    }

}

