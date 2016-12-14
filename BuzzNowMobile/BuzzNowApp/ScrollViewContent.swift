//
//  ScrollViewContent.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/28/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class ScrollViewContent: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    class func instanceFromNib() -> ScrollViewContent {
        return UINib(nibName: "ScrollViewContent", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ScrollViewContent
    }
}
