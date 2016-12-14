//
//  SlideInProfileSettingView.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 11/14/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

struct ProfileSettingModel {
    let identifier: String
    let text: String
    let img: String
}

protocol SlideInProtocol {
    func dismiss()
    func cellDidSelected(id: String)
}

class SlideInProfileSettingView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cover: UIView!
    
    var delegate: SlideInProtocol?

    private let dataProvider:[ProfileSettingModel] = [
        ProfileSettingModel(identifier: "account", text: "ACCOUNT", img: "ic_account"),
        ProfileSettingModel(identifier: "orderHistory", text: "ORDER HISTORY", img: "ic_order"),
        ProfileSettingModel(identifier: "shoppingHistory", text: "SHOPPING HISTORY", img: "ic_shopping"),
        ProfileSettingModel(identifier: "help", text: "HELP", img: "ic_help"),
        ProfileSettingModel(identifier: "setting", text: "SETTING", img: "ic_settings")
    ]

    private let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        setupSlideInTableView()
        setupGesture()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ProfileSettingItemCell), forIndexPath: indexPath) as! ProfileSettingItemCell
        cell.configure(dataProvider[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let obj = dataProvider[indexPath.row]
        delegate?.cellDidSelected(obj.identifier)
    }

    private func setupSlideInTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: String(ProfileSettingItemCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(ProfileSettingItemCell))
        tableView.tableFooterView = UIView()

        tableView.estimatedRowHeight = 80.0
    }

    private func setupGesture() {
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(dismiss))
        swipe.direction = .Left
        tableView.addGestureRecognizer(swipe)
    }

    @objc private func dismiss() {
        delegate?.dismiss()
    }
}
