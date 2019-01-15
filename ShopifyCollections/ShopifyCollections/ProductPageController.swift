//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

class ProductPageController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var collectionUrl: String?
    var products: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "cellId")

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .vertical
        layout?.minimumLineSpacing = 5

        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.tintColor = .white

        //Fetches Product IDs
        guard let collectionURL = self.collectionUrl else {return}
        fetchProductIds(productIdsURL: collectionURL)

    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if let count = products?.count {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ProductCell
        let selectedProduct = products?[indexPath.item]
        cell.product = selectedProduct
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 200, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2, bottom: 2, right: 2)
    }

    //Presenting extra product description.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = self.products?[indexPath.item]
        let layout = UICollectionViewFlowLayout()
        let bookdescripcontroller = ProductDescriptionController(collectionViewLayout: layout)
        bookdescripcontroller.product = selectedProduct
        let navController = UINavigationController(rootViewController: bookdescripcontroller)
        present(navController, animated: true, completion: nil)
    }

    //Fetches Product IDs
    func fetchProductIds(productIdsURL: String) {
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "access_token") else {return}
        guard let productIdsURL = URL(string: productIdsURL) else {return}

        URLSession.shared.dataTask(with: productIdsURL) { (data, _, error) in
            if let error = error {
                print("Failed to load the URL: \(productIdsURL)", error)
            }

            guard let data = data else {return}
            var productIdArray: [String] = []

            // Serializing JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let collectsDictionaries = json as? [String: Any] else {return}
                guard let collectDict = collectsDictionaries["collects"] else {return}

                var productIds: String = ""

                for dict in collectDict as! [AnyObject] {
                    guard let id = dict["product_id"] as? Int else {return}
                    productIdArray.append(String(id))
                }

                for element in productIdArray {
                    productIds += element + ","
                }

                productIds.popLast()

                let productUrl = "https://shopicruit.myshopify.com/admin/products.json?" +
                                 "ids=\(productIds)&page=1&access_token=\(accessToken)"

                self.getProductData(productURL: productUrl)

            }catch let jsonError {
                print("Failed to parse JSON: ", jsonError)
            }

        }.resume()
    }

    // Fetches Product Data
    func getProductData(productURL: String) {
        guard let productURL = URL(string: productURL) else {return}

        URLSession.shared.dataTask(with: productURL) { (data, _, error) in
            if let error = error {
                print("Failed to load the URL: \(productURL)", error)
            }

            guard let data = data else {return}

            // Serializing JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let productDictionaries = json as? [String: Any] else {return}
                guard let productDict = productDictionaries["products"] else {return}

                self.products = []

                for dict in productDict as! [AnyObject] {
                    let newProduct = Product(dataDictionary: dict)
                    self.products?.append(newProduct)
                }

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }catch let jsonError {
                print("Failed to parse JSON", jsonError)
            }

        }.resume()
    }
}
