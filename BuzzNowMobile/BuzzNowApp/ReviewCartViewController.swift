//
//  ReviewCartViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 11/7/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class CartItemModel: NSObject, UITextFieldDelegate {
    var num: String = "1"

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = NSString(string: num)
        num = oldString.stringByReplacingCharactersInRange(range, withString: string)
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        num = textField.text ?? "0"
        textField.resignFirstResponder()
    }
}

class ReviewCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var priceLabel: UILabel!

    var products:[Product] = [] {
        didSet {
            setupNumDict()
            tableView?.reloadData()
        }
    }

    private var numDict:[CartItemModel] = []
    private var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private let networkManager = ((UIApplication.sharedApplication().delegate) as! AppDelegate).networkManager

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        var price: Float = 0
        _ = products.flatMap{ price += Float($0.price ?? 0) }
        priceLabel.text = "$\(price)"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        navigationController!.navigationBar.topItem?.title = "Shopping Cart"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CartItemCell), forIndexPath: indexPath) as! CartItemCell
        cell.configureCell(products[indexPath.row])
        cell.numTextField.delegate = numDict[indexPath.row]
        let product = products[indexPath.row]
        let imgUrl = "/product/" + ((product.id)! as String) + ".jpg"
        networkManager.downloadImage(imgUrl) { (image) in
            dispatch_async(dispatch_get_main_queue(), {
                cell.imageIcon?.image = image
            })
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    private func setupTableView() {
        let nib = UINib(nibName: String(CartItemCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(CartItemCell))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.estimatedRowHeight = 105.0
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func submitOrder() {
        let order = context.createOrFetchOrder()
        let orderItems:[OrderItem] = products.map {
            let orderItem = context.createOrFetchOrderItem()
            orderItem.num = 1
            orderItem.product = $0
            return orderItem
        }
        order.requester = context.primaryUser()
        order.items = NSSet(array: orderItems)
        networkManager.submitOrder(order){ [weak self] in
            self?.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    private func setupNumDict() {
        numDict = products.map{ _ in
            let item = CartItemModel()
            return item
        }
    }
}
