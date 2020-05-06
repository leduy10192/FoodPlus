//
//  ItemCell.swift
//  projectFood+
//
//  Created by Ge Ou on 2020/5/6.
//  Copyright © 2020 Ge Ou. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var addressLabel: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addToCartButton(_ sender: Any) {
        
    }
}
