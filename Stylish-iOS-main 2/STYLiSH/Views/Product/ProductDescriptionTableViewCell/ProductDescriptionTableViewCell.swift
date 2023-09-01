//
//  ProductDescriptionTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProductDescriptionTableViewCell: ProductBasicCell {

    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var priceLbl: UILabel!

    @IBOutlet weak var idLbl: UILabel!

    @IBOutlet weak var detailLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutCell(product: Product) {
        titleLbl.text = product.title
        priceLbl.text = "NT$ \(product.price)"
        idLbl.text = String(product.id)
        detailLbl.text = product.story
    }
}
