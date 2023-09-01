//
//  STOrderProductCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/25.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class STOrderProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var productSizeLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    func layoutCell(data: STOrderProductCellViewModel?) {
        productImageView.loadImage(data?.imageUrl)
        productTitleLabel.text = data?.title
        productSizeLabel.text = data?.size
        priceLabel.text = data?.price
        orderNumberLabel.text = data?.pieces
        guard let colorCode = data?.color else {
            colorView.backgroundColor = .white
            return
        }
        colorView.backgroundColor = .hexStringToUIColor(hex: colorCode)
    }
}
