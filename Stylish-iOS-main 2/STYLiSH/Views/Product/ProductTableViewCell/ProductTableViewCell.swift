//
//  ProductTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/15.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImg: UIImageView!

    @IBOutlet weak var productTitleLbl: UILabel!

    @IBOutlet weak var productPriceLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func layoutCell(image: String, title: String, price: Int) {
        productImg.loadImage(image, placeHolder: .asset(.Image_Placeholder))
        productTitleLbl.text = title
        productPriceLbl.text = String(price)
    }
}
