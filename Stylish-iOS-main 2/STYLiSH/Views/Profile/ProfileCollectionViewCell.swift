//
//  ProfileCollectionViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var textLbl: UILabel!

    func layoutCell(image: UIImage?, text: String) {
        imgView.image = image
        textLbl.text = text
    }

}
