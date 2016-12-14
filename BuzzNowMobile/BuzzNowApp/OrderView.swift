//
//  OrderView.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/2/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class OrderView: UITableViewCell {
    @IBOutlet weak var esitimateTotal: UILabel!
    @IBOutlet weak var esitimateWeight: UILabel!
    @IBOutlet weak var esitimateTips: UILabel!
    @IBOutlet weak var numOfItems: UILabel!

    @IBOutlet weak var nameLabel :UILabel!
    @IBOutlet weak var addrLabel :UILabel!
    @IBOutlet weak var selectButton: SelectOrderButton!

    @IBOutlet weak var imageIcon:UIImageView!
    @IBOutlet weak var bkgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ColorAssets.lightGray()
        selectButton.setTitle("select order", forState: .Normal)

        imageIcon.layer.cornerRadius = 39.0
        imageIcon.clipsToBounds = true
        selectButton.userInteractionEnabled = false

        bkgView.layer.cornerRadius = 5
        bkgView.clipsToBounds = true
    }
}
