//
//  ProductListTableCell.swift
//  JSONParser
//
//  Created by doxper on 18/06/19.
//  Copyright © 2019 amitgajjar. All rights reserved.
//

import UIKit

class ProductListTableCell: UITableViewCell {
    
    // MARK: Properties & Outlets
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    // MARK: View Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: Internal Methods
    internal func fillCellData(forTag tag: Int, product: Product?) {
        self.tag = tag
        productTitleLabel.text = product?.title
        productDescriptionLabel.text = product?.subCategory
        productPriceLabel.text = "\u{20B9} \(product?.price ?? "0")"
    }
}
