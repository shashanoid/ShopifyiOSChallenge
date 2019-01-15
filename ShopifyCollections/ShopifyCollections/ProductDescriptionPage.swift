//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

class ProductDescriptionPage: UICollectionViewCell {

    // Casting product info. into subviews
    var product: Product? {
        didSet {
            productTitle.text = product?.title
            productDescription.text = product?.description
            vendorTitle.text = product?.vendor
            variantTypes.text = product?.variants

            let productImageURL = product?.productImageURL
            guard let imageURL = URL(string: productImageURL!) else {return}

            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let error = error {
                    print("Error in fetching product image:", error)
                }

                guard let imageData = data else {return}
                let image = UIImage(data: imageData)

                DispatchQueue.main.async {
                    self.productImage.image = image
                }
            }.resume()
        }
    }

    let productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productImage.backgroundColor = UIColor(red:0.87, green:0.89, blue:0.91, alpha:1.0)
        productImage.layer.cornerRadius = 10

        return productImage
    }()

    let productTitle: UILabel = {
        let productTitle = UILabel()
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        return productTitle
    }()

    let vendorTitle: UILabel = {
        let vendorTitle = UILabel()
        vendorTitle.font = UIFont.systemFont(ofSize: 15)
        vendorTitle.translatesAutoresizingMaskIntoConstraints = false
        vendorTitle.font = UIFont.systemFont(ofSize: 18)

        return vendorTitle
    }()

    let productDescription: UILabel = {
        let productDescription = UILabel()
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        productDescription.font = UIFont.systemFont(ofSize: 15)
        productDescription.textColor = UIColor(red:0.27, green:0.31, blue:0.36, alpha:1.0)

        return productDescription
    }()

    let variantLabel: UILabel = {
        let variantLabel = UILabel()
        variantLabel.text = "Also available in:"
        variantLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        variantLabel.translatesAutoresizingMaskIntoConstraints = false
        return variantLabel
    }()

    let variantTypes: UILabel = {
        let variantTypes = UILabel()
        variantTypes.numberOfLines = 0
        variantTypes.font = UIFont.systemFont(ofSize: 15)
        variantTypes.translatesAutoresizingMaskIntoConstraints = false

        return variantTypes
    }()

    let dividerLine: UIView = {
        let dividerLine = UIView()
        dividerLine.backgroundColor = .black
        dividerLine.translatesAutoresizingMaskIntoConstraints = false

        return dividerLine
    }()
    
    let buyButton: UIButton = {
        let buyButton = UIButton()
        buyButton.backgroundColor = UIColor(red:0.31, green:0.72, blue:0.24, alpha:1.0)
        buyButton.setTitle("Buy now", for: .normal)
        buyButton.layer.cornerRadius = 8
        buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        buyButton.titleLabel?.textAlignment = .center
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        return buyButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        //Adding the subviews
        addSubview(productImage)
        productImage.widthAnchor.constraint(equalToConstant: 300).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        productImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        productImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        productImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 80).isActive = true

        addSubview(productTitle)
        productTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        productTitle.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 12).isActive = true

        addSubview(vendorTitle)
        vendorTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        vendorTitle.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 10).isActive = true

        addSubview(productDescription)
        productDescription.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        productDescription.topAnchor.constraint(equalTo: vendorTitle.bottomAnchor,
                                                constant: 20).isActive = true

        addSubview(variantLabel)
        variantLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        variantLabel.topAnchor.constraint(equalTo: productDescription.bottomAnchor,
                                          constant: 30).isActive = true
        variantLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -265).isActive = true

        addSubview(variantTypes)
        variantTypes.leftAnchor.constraint(equalTo: variantLabel.rightAnchor, constant: 10).isActive = true
        variantTypes.topAnchor.constraint(equalTo: productDescription.bottomAnchor,
                                          constant: 30).isActive = true
        variantTypes.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

        
        addSubview(dividerLine)
        dividerLine.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        dividerLine.topAnchor.constraint(equalTo: variantTypes.bottomAnchor, constant: 15).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 2).isActive = true

        addSubview(buyButton)
        buyButton.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 30).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        buyButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
