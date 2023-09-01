//
//  AmountSelectionCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/5.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class AmountSelectionCell: UITableViewCell {

    @IBOutlet weak var selectionView: TrolleySelectionView!

    @IBOutlet weak var stockLbl: UILabel!

    var amount: Int? {
        return selectionView.inputField.text == nil ? nil : Int(selectionView.inputField.text!)
    }

    var variant: Variant?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView.isEnable(false, maxNumber: nil)
    }

    func layoutCell(variant: Variant?) {
        guard let data = variant else {
            selectionView.isEnable(false, maxNumber: nil)
            stockLbl.isHidden = true
            return
        }
        self.variant = variant
        selectionView.isEnable(true, maxNumber: data.stock)
        stockLbl.isHidden = false
        stockLbl.text = "庫存：\(data.stock)"
    }
}
