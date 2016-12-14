//
//  RootViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 9/29/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SlideInProtocol {

    @IBOutlet private var welcomeLabel: UILabel!
    @IBOutlet private var greetingPhrase: UITextView!
    @IBOutlet private var tableView: UITableView!
    
    private let context =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    private var onboardingFlowController: OnboardingFlowController!
    private let dataProvider = [["img_url" : "illu_requester.png", "text":"Request a Shopper", "identifier":"requester"],["img_url" : "illu_shopper.png", "text":"Become a Shopper", "identifier":"shopper"]]

    private lazy var slideInView: SlideInProfileSettingView = {
        let view = NSBundle.mainBundle().loadNibNamed(String(SlideInProfileSettingView), owner: ProfileHeaderView.self, options: nil)![0] as! SlideInProfileSettingView
        view.delegate = self
        return view
    }()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = ColorAssets.marigold()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (NSUserDefaults.standardUserDefaults().objectForKey("primaryID") == nil) {
            let navigationController = UINavigationController()
            onboardingFlowController = OnboardingFlowController(nav: navigationController)
            presentViewController(navigationController, animated: true, completion: nil)
        } else {
            commonInit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func commonInit() {
        tableView.registerNib(UINib(nibName: String(RootButtonViewCell), bundle: nil), forCellReuseIdentifier: String(RootButtonViewCell))
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        if let user = context.getPrimaryCurrentUser() {
            self.welcomeLabel.text = "Hi ".stringByAppendingString(user.name!)
        }

        let networkManager = (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager
        networkManager.fetchPrimaryUser { [unowned self] user in
           dispatch_async(dispatch_get_main_queue(), {
                self.welcomeLabel.text = "Hi ".stringByAppendingString(user.name!)
                self.slideInView.nameLabel.text = user.name
           })
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(RootButtonViewCell), forIndexPath: indexPath) as! RootButtonViewCell
        cell.imageIcon.image = UIImage(named: dataProvider[indexPath.row]["img_url"]!)
        cell.actionLabel.text = dataProvider[indexPath.row]["text"]!
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cellIdentifier = dataProvider[indexPath.row]["identifier"]
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if cellIdentifier == "requester" {
            navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("shop")
            navigationController?.pushViewController(vc, animated: true)
        } else if cellIdentifier == "shopper" {
            let vc = storyboard.instantiateViewControllerWithIdentifier("request")
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }

    @IBAction func showProfileSettingView() {
        slideInView.frame = CGRect(x: -1 * view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
        slideInView.cover.alpha = slideInView.cover.alpha == 0 ? slideInView.cover.alpha : 0
        view.addSubview(slideInView)

        UIView.animateWithDuration(0.3, animations: { [unowned self] in
            self.slideInView.frame = self.slideInView.frame.offsetBy(dx: self.view.frame.width, dy: 0)
        }) { [unowned self] (complete) in
            self.slideInView.cover.alpha = 1.0
        }
    }

    func dismiss() {
        slideInView.cover.alpha = 0
        UIView.animateWithDuration(0.3) { [unowned self] in
            self.slideInView.frame = self.slideInView.frame.offsetBy(dx: -1 * self.view.frame.width, dy: 0)
        }
    }

    func cellDidSelected(id: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        switch id {
        case "account":
            return
        case "orderHistory":
            let vc = storyboard.instantiateViewControllerWithIdentifier("orderHistory")
            navigationController?.pushViewController(vc, animated: true)
            return
        case "shoppingHistory":
            return
        default:
            return
        }
    }
}
