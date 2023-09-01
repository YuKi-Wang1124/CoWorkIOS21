//
//  SizeSelectionCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/5.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

enum StockStatus {
    case avaliable
    case unAvaliable
    case selected
    case disable
}

struct SizeObject {
    let size: String
    var status: StockStatus
}

class SizeSelectionCell: BasicSelectionCell {

    var sizes: [String] = [] {
        didSet {
            var result: [SizeObject] = []
            for size in sizes {
                let object = SizeObject(size: size, status: .disable)
                result.append(object)
            }
            sizeObjects = result
        }
    }

    private var sizeObjects: [SizeObject] = [] {
        didSet {
            reloadData()
        }
    }

    var avalibleSizes: [String] = [] {
        didSet {
            for index in 0 ..< sizes.count {
                if avalibleSizes.contains(sizeObjects[index].size) {
                    sizeObjects[index].status = .avaliable
                } else {
                    sizeObjects[index].status = .unAvaliable
                }
            }
            reloadData()
        }
    }

    var touchHandler: ((String) -> Bool)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLetterSpacing()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLetterSpacing()
    }

    private func setupLetterSpacing() {
        titleLbl.text = "選擇尺寸"
    }

    override func numberOfItem(_ cell: BasicSelectionCell) -> Int {
        return sizes.count
    }

    override func viewIn(_ cell: BasicSelectionCell, selectionCell: SelectionCell, indexPath: IndexPath) {
        guard let sizeView = selectionCell.objectView as? SizeView else {
            let sizeView = SizeView()
            sizeView.layoutCell(with: sizeObjects[indexPath.row])
            selectionCell.objectView = sizeView
            return
        }
        sizeView.layoutCell(with: sizeObjects[indexPath.row])
    }

    override func didSelected(_ cell: BasicSelectionCell, at indexPath: IndexPath) {
        if sizeObjects[indexPath.row].status == .unAvaliable || sizeObjects[indexPath.row].status == .disable {
            return
        }
        guard touchHandler?(sizeObjects[indexPath.row].size) == true else { return }
        for (index, object) in sizeObjects.enumerated() where object.status == .selected {
            sizeObjects[index].status = .avaliable
        }

        sizeObjects[indexPath.row].status = .selected

        collectionView.reloadData()
    }
}

private class SizeView: UIView {

    lazy var sizeLbl: UILabel = {
        let label = UILabel()
        stickSubView(label, inset: UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0))
        label.textAlignment = .center
        label.backgroundColor = .B5
        return label
    }()

    lazy var slashImg: UIImageView = {
        let imageView = UIImageView()
        stickSubView(imageView)
        imageView.image = .asset(.Image_StrikeThrough)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        return imageView
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
        sizeLbl.textColor = .B1
        slashImg.isHidden = true
        layer.borderWidth = 1
    }

    func layoutCell(with object: SizeObject) {
        sizeLbl.text = object.size
        layer.borderColor = UIColor.B5?.cgColor
        backgroundColor = .B5
        sizeLbl.textColor = .B1
        slashImg.isHidden = true

        switch object.status {
        case .avaliable: break
        case .unAvaliable:
            slashImg.isHidden = false
            sizeLbl.textColor = .B1?.withAlphaComponent(0.4)
        case .selected:
            layer.borderColor = UIColor.B1?.cgColor
            backgroundColor = .white
        case .disable:
            sizeLbl.textColor = .B1?.withAlphaComponent(0.4)
        }
    }
}
