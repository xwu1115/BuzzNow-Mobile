//
//  RootNavigationController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/9/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationBar.barTintColor = ColorAssets.barLightGray()
        navigationBar.tintColor = ColorAssets.black()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.blackColor(),
             NSFontAttributeName: UIFont(name: "SourceSansPro-Semibold", size: 18)!]
    }
}
