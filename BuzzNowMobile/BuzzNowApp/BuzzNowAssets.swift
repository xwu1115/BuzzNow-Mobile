//
//  File.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/28/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

struct ColorAssets {
    static func marigold() -> UIColor {
        return UIColor(red: 255/255.0, green: 190/255.0, blue: 0/255.0, alpha: 1)
    }

    static func darkMint() -> UIColor {
        return UIColor(red: 69/255.0, green: 191/255.0, blue: 85/255.0, alpha: 1)
    }

    static func black() -> UIColor {
        return UIColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1)
    }

    static func lightGray() -> UIColor {
        return UIColor(red: 241/255.0, green: 243/255.0, blue: 242/255.0, alpha: 1)
    }

    static func barLightGray() -> UIColor {
        return UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 0.12)
    }

    static func silver() -> UIColor {
        return UIColor(red:205/255.0 , green:210/255.0, blue:213/255.0, alpha: 1.0)
    }
}

struct FontAssets {
    static func TextViewFont() -> UIFont? {
        return UIFont(name: "SourceSansPro-Regular", size: 14)
    }
}

class OnboardingNextButton: UIButton {
    override func awakeFromNib() {
        backgroundColor = ColorAssets.darkMint()
        layer.cornerRadius = 24.0
        titleLabel!.font =  UIFont(name: "SourceSansPro-Semibold", size: 16)
        setTitleColor(UIColor.whiteColor(), forState:.Normal)
    }
}

class SelectOrderButton: UIButton {
    override func awakeFromNib() {
        backgroundColor = ColorAssets.darkMint()
        titleLabel!.font =  UIFont(name: "SourceSansPro-Semibold", size: 16)
        setTitleColor(UIColor.whiteColor(), forState:.Normal)
    }
}

class OnboardingLoginButton: UIButton {
    override func awakeFromNib() {
        backgroundColor = ColorAssets.marigold()
        layer.cornerRadius = 24.0
        titleLabel!.font =  UIFont(name: "SourceSansPro-Semibold", size: 16)
        setTitleColor(UIColor.blackColor(), forState:.Normal)
    }
}
