//
//  OnboardingBaseViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class OnboardingBaseViewController: UIViewController {
    var flowController: NavigationFlowContainer?
    private var context: NSManagedObjectContext!

    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
