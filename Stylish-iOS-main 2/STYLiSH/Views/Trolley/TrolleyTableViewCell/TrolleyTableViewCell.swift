//
//  TrolleyTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class TrolleyTableViewCell: UITableViewCell {

    @IBOutlet weak var trolleyBaseView: TrolleyProductBaseView!

    @IBOutlet weak var trolleySelectionView: TrolleySelectionView?

    @IBOutlet weak var productImg: UIImageView!

    @IBOutlet weak var amountLbl: UILabel?

    var touchHandler: (() -> Void)? {
        didSet {
            trolleyBaseView.touchHandler = touchHandler
        }
    }

    var valueChangeHandler: ((Int) -> Void)? {
        didSet {
            trolleySelectionView?.valueChangeHandler = valueChangeHandler
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        trolleySelectionView?.isEnable(true, maxNumber: nil)
        trolleyBaseView.touchHandler = nil
    }

    func layoutView(order: LSOrder) {
        guard
            let product = order.product,
            let title = product.title,
            let size = order.seletedSize,
            let color = order.selectedColor?.toColor(),
            let image = product.images?[0],
            let variants = product.variants as? Set<LSVariant>
        else {
            return
        }
        trolleyBaseView.layoutView(title: title, size: size, price: String(Int(product.price)), color: color.code)

        productImg.loadImage(image)

        let variant: [LSVariant] = variants.compactMap { variant in
            if variant.size == size && variant.colorCode == color.code {
                return variant
            }
            return nil
        }

        guard let maxNumber = variant.first?.stocks else { return }
        trolleySelectionView?.isEnable(true, maxNumber: Int(maxNumber), amount: Int(order.amount))
        amountLbl?.text = "x \(order.amount)"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        touchHandler = nil
        valueChangeHandler = nil
    }
}
