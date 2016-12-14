//
//  ProductViewCell.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/12/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class ProductViewCell: UICollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bkgndView: UIView!

    func configure(product: Product) {
        priceLabel.text = "$" + String(product.price!)
        nameLabel.text = String(product.name!)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = UIColor.whiteColor()
        bkgndView.backgroundColor = UIColor.whiteColor()
    }
}
