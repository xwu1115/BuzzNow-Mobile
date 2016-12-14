//
//  AuthorizeViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class AuthorizeViewController: OnboardingBaseViewController {
    @IBOutlet weak var loginBtn: OnboardingLoginButton!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loginBtn.setTitle("LOGIN", forState: .Normal)
    }

    @IBAction func backButtonPressed() {
        flowController?.pop()
    }

    @IBAction func nextButtonPressed() {
        flowController?.pushNext()
    }
}
