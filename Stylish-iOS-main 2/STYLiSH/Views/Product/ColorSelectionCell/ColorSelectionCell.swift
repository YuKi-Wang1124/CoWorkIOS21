//
//  ColorSelectionCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/5.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

private struct ColorObject {
    let color: String
    var isSelected: Bool
}

class ColorSelectionCell: BasicSelectionCell {

    var colors: [String] = [] {
        didSet {
            colorObjects = colors.map { color in
                let object = ColorObject(color: color, isSelected: false)
                return object
            }
        }
    }

    var touchHandler: ((IndexPath) -> Void)?

    private var colorObjects: [ColorObject] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupColorView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupColorView()
    }

    private func setupColorView() {
        titleLbl.text = "選擇顏色"
        titleLbl.characterSpacing = 2.1
    }

    override func numberOfItem(_ cell: BasicSelectionCell) -> Int {
        return colorObjects.count
    }

    override func viewIn(_ cell: BasicSelectionCell, selectionCell: SelectionCell, indexPath: IndexPath) {
        guard let colorView = selectionCell.objectView as? ColorView else {
            let colorView = ColorView()
            colorView.layoutCell(color: colorObjects[indexPath.row].color, isSelected: false)
            selectionCell.objectView = colorView
            return
        }

        colorView.layoutCell(
            color: colorObjects[indexPath.row].color,
            isSelected: colorObjects[indexPath.row].isSelected
        )
    }

    override func didSelected(_ cell: BasicSelectionCell, at indexPath: IndexPath) {
        for index in 0 ..< colorObjects.count {
            colorObjects[index].isSelected = false
        }
        colorObjects[indexPath.row].isSelected = !colorObjects[indexPath.row].isSelected
        touchHandler?(indexPath)

        collectionView.reloadData()
    }
}

private class ColorView: UIView {

    lazy var contentView: UIView = {
        let contentView = UIView()
        stickSubView(contentView, inset: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        return contentView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initView()
    }

    func initView() {
        layer.borderWidth = 1
    }

    func layoutCell(color: String, isSelected: Bool) {
        contentView.backgroundColor = .hexStringToUIColor(hex: color)

        if isSelected {
            backgroundColor = .white
            layer.borderColor = UIColor.B1?.cgColor
        } else {
            backgroundColor = .hexStringToUIColor(hex: color)
            layer.borderColor = UIColor.hexStringToUIColor(hex: color).cgColor
        }
    }
}
