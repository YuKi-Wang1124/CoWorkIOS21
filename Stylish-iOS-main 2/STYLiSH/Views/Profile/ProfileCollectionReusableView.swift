//
//  ProfileCollectionReusableView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLbl: UILabel!

    @IBOutlet weak var actionBtn: UIButton!

    func layoutView(title: String, actionText: String?) {
        titleLbl.text = title
        actionBtn.setTitle(actionText ?? "", for: .normal)
    }
}
