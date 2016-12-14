//
//  OrderHistoryViewCell.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 11/19/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class OrderHistoryViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    private var imgQueue: [UIImageView] = []
    private let networkManager = (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager

    @IBOutlet private weak var img0: UIImageView!
    @IBOutlet private weak var img1: UIImageView!
    @IBOutlet private weak var img2: UIImageView!
    @IBOutlet private weak var img3: UIImageView!
    @IBOutlet private weak var img4: UIImageView!
    @IBOutlet private weak var img5: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        imgQueue.append(img0)
        imgQueue.append(img1)
        imgQueue.append(img2)
        imgQueue.append(img3)
        imgQueue.append(img4)
        imgQueue.append(img5)
    }

    private func addImage(img: UIImage) {
        guard imgQueue.count > 0 else { return }

        let imgView = imgQueue.first
        imgView?.image = img
        imgQueue.removeFirst()
    }

    func configure(order: Order) {
        guard let orderItem = order.items?.allObjects as? [OrderItem] else { return }
        guard let status = order.status else { return }

        timeLabel.text = String(order.creation_time ?? NSDate(timeIntervalSinceNow: 0))
        switch status {
        case 0:
            statusLabel.text = "Waiting for a shopper"
        case 1:
            let buyer = order.buyer?.name ?? ""
            statusLabel.text = "\(buyer) shopped for you"
        default:
            break
        }
        var count = 0
        var price: Float = 0
        for item in orderItem {
            let id = "/product/\(item.product?.id ?? "").jpg"
            networkManager.downloadImage(id, completion: { [unowned self] img in
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    self.addImage(img)
                })
            })
            count += item.num?.integerValue ?? 0
            price += item.totalPrice
        }
        countLabel.text = "\(count) items"
        priceLabel.text = "$\(price) + \(price * 0.1)"
    }
}
