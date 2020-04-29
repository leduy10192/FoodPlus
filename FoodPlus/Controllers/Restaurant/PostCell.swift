//
//  PostCell.swift
//  FoodPlus
//
//  Created by Duy Le on 4/24/20.
//  Copyright © 2020 Duy Le. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var editLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        priceLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // Initialization code
    }

}
