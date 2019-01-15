//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var DataCacheURL: URL?
    var collections: [Collection]?
    var collectionURLs: [String]?
    
    let CacheQueue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Bar Attributes
        navigationController?.navigationBar.barTintColor = UIColor(red:0.11, green:0.13, blue:0.38, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Collections"

        // Register Custom Cells
        tableView.register(CollectionCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()

        //Fetches collection Data
        fetchCollectionData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = collections?.count {
            return count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CollectionCell
        let selectedCollection = collections?[indexPath.row]
        cell.collection = selectedCollection!
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    // Selects a collection and pushed the data to collectionview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUrl = collectionURLs?[indexPath.row]
        let selectedCollection = collections?[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let productPage = ProductPageController(collectionViewLayout: layout)
        productPage.collectionUrl = selectedUrl
        productPage.navigationItem.title = selectedCollection?.title
        navigationController?.pushViewController(productPage, animated: true)
    }

    //Fetching Json Data for Collections
    func fetchCollectionData() {
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "access_token") else {return}
        guard let collectionsURL = URL(string: """
            https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=\(accessToken)
            """) else {return}
        
        
        URLSession.shared.dataTask(with: collectionsURL) { (data, _, error) in
            if let error = error {
                print("Failed to load the URL: \(collectionsURL)", error)
            }

            guard let data = data else {return}
            let allowedCollections = ["aerodynamic-collection", "durable", "small-collection"]
            
            // Serializing JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let collectionDictionaries = json as? [String: Any] else {return}
                guard let collectionDict = collectionDictionaries["custom_collections"] else {return}

                self.collections = []
                self.collectionURLs = []

                //Collection Dictionary with Collection ID
                for dict in collectionDict as! [AnyObject]{
                    guard let handleName = dict["handle"] as? String else {return}

                    if allowedCollections.contains(handleName) {
                        let newcollection = Collection(dataDictionary: dict as AnyObject)
                        self.collections?.append(newcollection)

                        // Creating Product Url
                        guard let collectionId = dict["id"] as? Int else {return}
                        let collectionUrl = "https://shopicruit.myshopify.com/admin/collects.json?" +
                        "collection_id=\(String(collectionId))&page=1&access_token=\(accessToken)"
                        self.collectionURLs?.append(collectionUrl)

                    }
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let jsonError {
                print("Failed to parse JSON:", jsonError)
            }
        }.resume()
    }

}
