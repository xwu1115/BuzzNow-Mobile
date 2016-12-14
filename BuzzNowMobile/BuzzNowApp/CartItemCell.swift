//
//  CartItemCell.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 11/7/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class CartItemCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        numTextField.text = "1"
    }

    func configureCell(product: Product) {
        nameLabel.text = product.name
        priceLabel.text = "\(product.price ?? 0) x "
    }
}
