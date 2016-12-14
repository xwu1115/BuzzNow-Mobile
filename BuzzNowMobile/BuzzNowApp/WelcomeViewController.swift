//
//  WelcomeViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/27/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class WelcomeViewController: OnboardingBaseViewController, ScrollViewStatusDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: OnboardingNextButton!
    @IBOutlet weak var pageIndicator: UIPageControl!

    private var viewModel: OnboardingScrollViewModel?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = ColorAssets.marigold()
        nextButton.setTitle("Get Started with Your GT Account", forState: .Normal)
    }

    override func viewDidLayoutSubviews() {
        viewModel = OnboardingScrollViewModel(sc: scrollView, delegate: self)
    }

    @IBAction func nextButtonPressed() {
        flowController?.pushNext()
    }

    func updateScrollViewIndicator(num: Int) {
        pageIndicator.currentPage = num
    }

    func setUpIndicator(num: Int) {
        pageIndicator.numberOfPages = num
    }
}
