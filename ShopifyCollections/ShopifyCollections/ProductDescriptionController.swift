//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

class ProductDescriptionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        layout?.minimumLineSpacing = 0

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain,
                                                           target: self, action: #selector(handleClose))

        //Navigation Bar configurations
        navigationController?.navigationBar.barTintColor = UIColor(red:0.11, green:0.13, blue:0.38, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white

        collectionView.register(ProductDescriptionPage.self, forCellWithReuseIdentifier: "cellId")
    }

    @objc func handleClose() {
        dismiss(animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId",
                                                      for: indexPath) as! ProductDescriptionPage
        cell.product = self.product
        return cell
    }

    //Page sized cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

}
