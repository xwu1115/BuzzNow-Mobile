//
//  OnboardingScrollView.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/28/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class OnboardingScrollViewModel: NSObject, UIScrollViewDelegate {
    private let scrollView: UIScrollView
    private var contentDict = [
        ["img_url":"logo_l.png",
        "content":"Donec sed odio dui. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. "],
        ["img_url":"logo_l.png",
        "content":"Donec sed odio dui. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus."]
    ]
    private let pageWidth: CGFloat

    init(sc : UIScrollView) {
        scrollView = sc
        pageWidth = scrollView.frame.width
        super.init()
        setupScrollView()
        configureContent()
    }

    private func setupScrollView() {
        let frame = scrollView.frame
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        let num = contentDict.count
        scrollView.contentSize = CGSizeMake(frame.width * CGFloat(num), frame.height)
    }

    private func configureContent() {
        for i in 0 ..< contentDict.count {
            let item = contentDict[i]
            let currentView = ScrollViewContent.instanceFromNib()
            currentView.frame = CGRectMake(CGFloat(i) * pageWidth, 0, pageWidth, scrollView.frame.height)
            if let imgUrl = item["img_url"] {
                let image = UIImage(named: imgUrl)
                currentView.imageView.image = image
            }
            currentView.textView.font = FontAssets.TextViewFont()
            currentView.textView.text = item["content"]
            scrollView.addSubview(currentView)
        }
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let numPages = offset.x / pageWidth
        scrollView.contentOffset = CGPointMake(numPages * pageWidth, offset.y)
    }
}
