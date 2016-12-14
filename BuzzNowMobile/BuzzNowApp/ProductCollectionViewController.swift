//
//  ProductCollectionViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/12/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit
import CoreData

class ProductCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    private let networkManager = (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager
    private var selectedProducts:[Product] = [] {
        didSet {
            var price: Float = 0.0
            _ = selectedProducts.flatMap { price += ($0.price?.floatValue) ?? 0 }
            totalPriceLabel.text = "$\(price)"
        }
    }
    private var dataProvider: NSFetchedResultsController?
    private var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    private let collectionLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "btn_back")
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "btn_back")
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        setUpCollectionView()
        setUpDataProvider()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.searchBarStyle = .Minimal
        if let textField = searchBar.valueForKey("_searchField") as? UITextField {
            textField.backgroundColor = UIColor(red: 243/255.0, green: 242/255.0, blue: 241/255.0, alpha: 1.0)
        }

        navigationController?.navigationBarHidden = true
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductViewCell), forIndexPath: indexPath) as! ProductViewCell
        if let product = dataProvider?.objectAtIndexPath(indexPath) as? Product {
            cell.configure(product)
            let imgUrl = "/product/" + ((product.id)! as String) + ".jpg"
            networkManager.downloadImage(imgUrl) { (image) in
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imageIcon?.image = image
                })
            }
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = dataProvider?.sections else {
            return 0
        }
        return sections[section].numberOfObjects ?? 0
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if let product = dataProvider?.objectAtIndexPath(indexPath) as? Product {
            if let index = selectedProducts.indexOf(product) {
                selectedProducts.removeAtIndex(index)
            } else {
                selectedProducts.append(product)
            }
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.reloadData()
    }

    @IBAction func backButtonPressed() {
        navigationController?.popViewControllerAnimated(true)
    }

    private func setUpCollectionView() {
        let nib = UINib(nibName: String(ProductViewCell), bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: String(ProductViewCell))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = collectionLayout
        collectionLayout.itemSize.width = CGFloat((view.bounds.size.width - 2.2) / 5.0)
        collectionLayout.minimumLineSpacing = 1.0
        collectionLayout.minimumInteritemSpacing = 1.0
        collectionLayout.itemSize.height = 160
        collectionView.backgroundColor = ColorAssets.silver()
    }

    private func setUpDataProvider() {
        let request = NSFetchRequest(entityName: "Product")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = NSPredicate(value: true)
        dataProvider = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        dataProvider?.delegate = self
        try! dataProvider?.performFetch()

        networkManager.fetchProducts()
    }

    @IBAction func reviewCart() {
        let vc = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("review") as! ReviewCartViewController
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        vc.products = selectedProducts
        navigationController?.pushViewController(vc, animated: true)
    }
}
