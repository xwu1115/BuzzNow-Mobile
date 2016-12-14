//
//  OrderHistoryViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 11/19/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class OrderHistoryViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    private var frc: NSFetchedResultsController?
    private let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBarHidden = false
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "btn_back")
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "btn_back")

        setupTableView()
        setupDataProvider()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)

        navigationController!.navigationBar.topItem?.title = "Order History"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc?.fetchedObjects?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(OrderHistoryViewCell), forIndexPath: indexPath) as! OrderHistoryViewCell
        if let obj = frc?.objectAtIndexPath(indexPath) as? Order {
            cell.configure(obj)
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: String(OrderHistoryViewCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: String(OrderHistoryViewCell))
        tableView.tableFooterView = UIView()

        tableView.estimatedRowHeight = 150.0
    }

    private func setupDataProvider() {
        if let id = NSUserDefaults.standardUserDefaults().valueForKey("primaryID") {
            let request = NSFetchRequest(entityName: "Order")
            request.predicate = NSPredicate(format: "requester.id == %@", argumentArray: [id])
            request.sortDescriptors = [NSSortDescriptor(key: "creation_time", ascending: true)]
            frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            frc?.delegate = self
            try! frc?.performFetch()
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}
