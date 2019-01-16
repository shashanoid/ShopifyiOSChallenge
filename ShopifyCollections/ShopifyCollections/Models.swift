//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

// Collection Class
class Collection {
    let title: String
    let description: String
    let collectionImageURL: String

    init(dataDictionary: AnyObject) {
        var title = ""
        var description = ""
        var collectionImageURL = ""
        
        if let imagedict = dataDictionary["image"] as? [String: Any] {
            let imagesrc = imagedict["src"] as? String
            title = dataDictionary["title"] as? String ?? ""
            description = dataDictionary["body_html"] as? String ?? ""
            collectionImageURL = imagesrc ?? ""
        }

        self.title = title
        self.description = description
        self.collectionImageURL = collectionImageURL
    }

}

//Product Class
class Product {
    let title: String
    let description: String
    let vendor: String
    let productImageURL: String
    let variants: String
    let inventoryCount: String

    init(dataDictionary: AnyObject) {
        self.title = dataDictionary["title"] as? String ?? ""
        self.description = dataDictionary["body_html"] as? String ?? ""
        let vendorName = dataDictionary["vendor"] as? String ?? ""
        var productImgSrc = ""
        var colors: String = ""
        var totalInventory: Int = 0
        
        // Gets images and variant types
        if let imagedict = dataDictionary["image"] as? [String: Any] {
            if let options = dataDictionary["options"] as? [[String: Any]] {
                let colorArray = options[0]["values"] as? NSArray

                for color in colorArray! {
                    if let color = color as? String{
                        colors += color + ", "
                    }
                }
                colors.popLast()
                colors.popLast()

                productImgSrc = imagedict["src"] as? String ?? ""
        
            }
        }
        
        // Gets Inventory count
        if let variantDict = dataDictionary["variants"] as? [[String: Any]]{
            for dict in variantDict{
                if let count = dict["inventory_quantity"] as? Int{
                    totalInventory += count
                }
            }
        }
        
        self.vendor = "By: " + vendorName
        self.productImageURL = productImgSrc
        self.variants = colors
        self.inventoryCount = String(totalInventory)
    }
}

