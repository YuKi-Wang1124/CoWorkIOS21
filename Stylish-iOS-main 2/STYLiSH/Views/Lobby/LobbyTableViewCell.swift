//
//  LobbyTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class LobbyTableViewCell: UITableViewCell {

    @IBOutlet weak var singleImgView: UIImageView!

    @IBOutlet weak var leftImgView: UIImageView!

    @IBOutlet weak var middleTopImgView: UIImageView!

    @IBOutlet weak var middleBottomImgView: UIImageView!

    @IBOutlet weak var rightImgView: UIImageView!

    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var descriptionLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func singlePage(img: String, title: String, description: String) {
        singleImgView.alpha = 1.0
        singleImgView.loadImage(img, placeHolder: .asset(.Image_Placeholder))
        titleLbl.text = title
        descriptionLbl.text = description
    }

    func multiplePages(imgs: [String], title: String, description: String) {
        singleImgView.alpha = 0.0

        leftImgView.loadImage(imgs[0], placeHolder: .asset(.Image_Placeholder))
        middleTopImgView.loadImage(imgs[1], placeHolder: .asset(.Image_Placeholder))
        middleBottomImgView.loadImage(imgs[2], placeHolder: .asset(.Image_Placeholder))
        rightImgView.loadImage(imgs[3], placeHolder: .asset(.Image_Placeholder))

        titleLbl.text = title
        descriptionLbl.text = description
    }
}
