//
//  TrolleyProductBaseView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class TrolleyProductBaseView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var sizeLbl: UILabel!

    @IBOutlet weak var priceLbl: UILabel!

    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var removeBtn: UIButton!

    var touchHandler: (() -> Void)? {
        didSet {
            if touchHandler == nil {
                removeBtn.isHidden = true
            } else {
                removeBtn.isHidden = false
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }

    private func initContentView() {
        backgroundColor = .white

        Bundle.main.loadNibNamed(
            String(describing: TrolleyProductBaseView.self),
            owner: self,
            options: nil
        )

        stickSubView(contentView)
    }

    @IBAction func didTouchRemoveButton(_ sender: UIButton) {
        touchHandler?()
    }

    func layoutView(title: String, size: String, price: String, color: String) {
        titleLbl.text = title
        sizeLbl.text = size
        priceLbl.text = price
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.B1?.cgColor
        colorView.backgroundColor = .hexStringToUIColor(hex: color)
    }
}
