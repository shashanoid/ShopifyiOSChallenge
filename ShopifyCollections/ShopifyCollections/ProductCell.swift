//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {

    // Casting product data into subviews
    var product: Product? {
        didSet {
            productTitle.text = product!.title
            productVendor.text = product!.vendor
            guard let productImageUrl = URL(string: ((product?.productImageURL)!)) else {return}

            URLSession.shared.dataTask(with: productImageUrl) { (data, _, error) in

                if let error = error {
                    print("Failed to product image: ", error)
                    return
                }

                guard let imageData = data else { return }
                let image = UIImage(data: imageData)

                DispatchQueue.main.async {
                    self.productImage.image = image
                }

                }.resume()
        }
    }

    let productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.backgroundColor = .white
        productImage.translatesAutoresizingMaskIntoConstraints = false
        return productImage
    }()

    let productTitle: UILabel = {
        let productTitle = UILabel()
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.numberOfLines = 0
        productTitle.font = UIFont.systemFont(ofSize: 18)
        return productTitle

    }()

    let productVendor: UILabel = {
        let productVendor = UILabel()
        productVendor.translatesAutoresizingMaskIntoConstraints = false
        productVendor.numberOfLines = 0
        productVendor.font = UIFont.systemFont(ofSize: 14)
        return productVendor
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red:0.87, green:0.89, blue:0.91, alpha:1.0)

        addSubview(productImage)
        productImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        productImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        productImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        productImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80).isActive = true

        addSubview(productTitle)
        productTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        productTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        productTitle.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 5).isActive = true

        addSubview(productVendor)
        productVendor.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        productVendor.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        productVendor.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 5).isActive = true

        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
