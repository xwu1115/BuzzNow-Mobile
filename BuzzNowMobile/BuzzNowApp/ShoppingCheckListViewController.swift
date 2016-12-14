//
//  ShoppingCheckListViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/7/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCheckListViewController: OrderBaseViewViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var doneButton: OnboardingLoginButton!
    let networkManager = (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager
    var orderId: String!

    private var dataProvider: [OrderItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let order = context.createOrFetchOrder(orderId)
        setUpTableView()
        dataProvider = (order.items?.allObjects as? [OrderItem]) ?? []
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.layer.cornerRadius = 0
        doneButton.setTitle("DONE SHOPPING", forState: .Normal)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        navigationController!.navigationBar.topItem?.title = "Shopping Checklist"
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: String(ProductCellView), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(ProductCellView))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = ColorAssets.lightGray()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductCellView), forIndexPath: indexPath) as! ProductCellView
        let orderItem = dataProvider[indexPath.row]
        if let product = orderItem.product {
            cell.nameLabel.text = product.name ?? ""
            cell.priceLabel.text = "$" + String(product.price!) + " x " + String(orderItem.num!)

            let imgUrl = "/product/" + product.id! + ".jpg"
            networkManager.downloadImage(imgUrl, completion: { (image) in
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageIcon?.image = image
                })
            })
        }
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    @IBAction func doneButtonPressed() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
