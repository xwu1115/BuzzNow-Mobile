//
//  CompleteViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class CompleteViewController: OnboardingBaseViewController {
    @IBOutlet weak var nextBtn: OnboardingNextButton!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        nextBtn.setTitle("DONE", forState: .Normal)
    }

    @IBAction func nextButtonPressed() {
        flowController?.pushNext()
    }

}
