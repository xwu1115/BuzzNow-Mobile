//
//  ProfileSettingItemCell.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 11/14/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class ProfileSettingItemCell: UITableViewCell {

    @IBOutlet private weak var imgIcon: UIImageView!
    @IBOutlet private weak var settingLabel: UILabel!

    func configure(item: ProfileSettingModel) {
        imgIcon.image = UIImage(named: item.img)
        settingLabel.text = item.text
    }
}
