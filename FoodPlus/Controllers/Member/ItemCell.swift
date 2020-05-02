//
//  ItemCell.swift
//  FoodPlus
//
//  Created by Duy Le on 4/29/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

protocol AlertDelegate{

    func presentAlert(title:String, message:String)

}
class ItemCell: UICollectionViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var cartIcon: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var greenCircleLabel: UIImageView!
    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
//    var delegate: AlertDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func cartIconPressed(_ sender: UIButton) {
//        let itemName = itemNameLabel.text!
//        delegate?.presentAlert(title: "Add to Cart", message: "Do you want to add \(itemName) to your cart?")
        
//        priceLabel.text = "Sold out"
//        priceLabel.textColor = #colorLiteral(red: 0.3724936843, green: 0, blue: 0.1352183819, alpha: 1)
//        greenCircleLabel.isHidden = true

    }

    
}
