//
//  SelectOrderViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/2/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class OrderBaseViewViewController: UIViewController {
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = ColorAssets.lightGray()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "btn_back")
        navigationController!.navigationBar.backIndicatorImage = UIImage(named: "btn_back")
    }
}

class SelectOrderViewController: OrderBaseViewViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    private var frc: NSFetchedResultsController?
    @IBOutlet private weak var tableView: UITableView!
    private let networkManager = (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSFetchRequest(entityName: "Order")
        request.sortDescriptors = [NSSortDescriptor(key: "creation_time", ascending: true)]
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc?.delegate = self
        try! frc?.performFetch()

        networkManager.fetchOrders()

        setUpTableView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = false
        navigationController!.navigationBar.topItem?.title = "Select Order(s)"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let obj = frc?.objectAtIndexPath(indexPath) as? Order {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(OrderView), forIndexPath: indexPath) as! OrderView
            return configureCell(obj, cell: cell)
        } else {
            return UITableViewCell()
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc!.sections![section].numberOfObjects
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 330
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if let obj = frc?.objectAtIndexPath(indexPath) as? Order {
            if let id = obj.id {
                showShoppingCheckListViewController(id)
            }
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ColorAssets.lightGray()
        let nib = UINib(nibName: String(OrderView), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(OrderView))
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = NSBundle.mainBundle().loadNibNamed("SelectOrderHeaderView", owner: SelectOrderHeaderView.self, options: nil)![0] as? UIView
        tableView.tableHeaderView?.frame = CGRectMake(0, 0, tableView.bounds.width, 15)
    }

    private func configureCell(order: Order, cell: OrderView) -> OrderView {
        var price: Float = 0.0
        var num: UInt32 = 0
        var weight: Float = 0.0

        if let orderItems = order.items?.allObjects as? [OrderItem] {
            for orderItem in orderItems {
                guard let product = orderItem.product else { continue }
                price += (product.price?.floatValue ?? 0) * (orderItem.num?.floatValue ?? 0)
                weight += (product.weight?.floatValue ?? 0) * (orderItem.num?.floatValue ?? 0)
                num += (orderItem.num?.unsignedIntValue ?? 0)
            }
        }

        cell.esitimateTotal.text = "$" + String(price)
        cell.esitimateWeight.text = String(weight) + "lb"
        cell.numOfItems.text = String(num)
        cell.esitimateTips.text = "$" + String(0.1 * price)

        cell.nameLabel.text = order.requester?.name ?? String(order.id)
        cell.addrLabel.text = order.requester?.address ?? String(order.id)
        cell.imageIcon?.image = UIImage(named: "illu_requester")
        if let id = order.requester?.id {
            let imgUrl = "/user/\(id).jpg"
            networkManager.downloadImage(imgUrl) { (image) in
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageIcon?.image = image
                })
            }
        }
        return cell
    }

    private func showShoppingCheckListViewController(id: String) {
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("checklist") as! ShoppingCheckListViewController
        vc.orderId = id
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}
