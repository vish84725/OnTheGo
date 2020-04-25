//
//  ProductTableViewCell.swift
//  OnTheGo
//
//  Created by Visal Hettiarachchi on 4/25/20.
//  Copyright © 2020 Visal Hettiarachchi. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(with product: Product)
    {
        productNameLabel.text = product.name
        amountLabel.text = String(product.quantity)
    }

}
