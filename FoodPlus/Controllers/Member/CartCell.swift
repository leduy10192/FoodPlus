//
//  CartCell.swift
//  FoodPlus
//
//  Created by Duy Le on 5/1/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var FoodNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
