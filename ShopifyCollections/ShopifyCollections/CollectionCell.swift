//  Shopify Collections
//
//  Created by Shashwat Singh
//  Copyright © 2019 Shashwat Singh. All rights reserved.
//

import UIKit

class CollectionCell: UITableViewCell {

    // Casting the data into subviews
    var collection: Collection? {
        didSet {
            collectionTitle.text = collection?.title
            guard let collectionImageUrl = collection?.collectionImageURL else {return}
            guard let imageURL = URL(string: collectionImageUrl) else {return}

            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in

                if let error = error {
                    print("Failed to retrieve collection image: ", error)
                    return
                }

                guard let imageData = data else { return }
                let image = UIImage(data: imageData)

                DispatchQueue.main.async {
                    self.collectionImage.image = image
                }

                }.resume()
        }
    }

    let collectionTitle: UILabel = {
        let collectionTitle = UILabel()
        collectionTitle.font = UIFont.systemFont(ofSize: 20)
        collectionTitle.translatesAutoresizingMaskIntoConstraints = false
        return collectionTitle
    }()

    let collectionDescription: UILabel = {
        let collectionDescription = UILabel()
        collectionDescription.text = "Collection of amazing goods"
        collectionDescription.font = UIFont.systemFont(ofSize: 12)
        collectionDescription.numberOfLines = 0
        collectionDescription.translatesAutoresizingMaskIntoConstraints = false
        return collectionDescription
    }()

    let collectionImage: UIImageView = {
        let collectionImage = UIImageView()
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        return collectionImage
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(collectionImage)
        collectionImage.widthAnchor.constraint(equalToConstant: 180).isActive = true
        collectionImage.heightAnchor.constraint(equalToConstant: 150).isActive = true

        addSubview(collectionTitle)
        collectionTitle.leftAnchor.constraint(equalTo: collectionImage.rightAnchor,
                                              constant: 20).isActive = true
        collectionTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 65).isActive = true

        addSubview(collectionDescription)
        collectionDescription.leftAnchor.constraint(equalTo: collectionImage.rightAnchor,
                                                    constant: 18).isActive = true
        collectionDescription.topAnchor.constraint(equalTo: collectionTitle.bottomAnchor,
                                                   constant: 20).isActive = true
        collectionDescription.widthAnchor.constraint(equalToConstant: frame.width - 10).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
