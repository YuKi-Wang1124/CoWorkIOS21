//
//  ProductDetailBasicCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProductDetailCell: ProductBasicCell {

    static let color = "ProductDetailColorCell"
    static let label = "ProductDetailLabelCell"

    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
            collectionView?.register(
                ProductColorCell.self,
                forCellWithReuseIdentifier: String(describing: ProductColorCell.self)
            )
        }
    }

    @IBOutlet weak var contentLbl: UILabel?

    @IBOutlet weak var categoryLbl: UILabel!

    private var colors: [String] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutCell(category: String, content: String) {
        categoryLbl.text = category
        contentLbl?.text = content
    }

    override func layoutCellWithColors(category: String, colors: [String]) {
        categoryLbl.text = category
        self.colors = colors
    }
}

// MARK: - UICollectionViewDataSource
extension ProductDetailCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductColorCell.self),
            for: indexPath
        )
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.B1?.cgColor
        cell.backgroundColor = .hexStringToUIColor(hex: colors[indexPath.row])
        return cell
    }
}

private class ProductColorCell: UICollectionViewCell {}
