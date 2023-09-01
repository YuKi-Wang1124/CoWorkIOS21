//
//  UILabel+Extension.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

@IBDesignable
extension UILabel {

    @IBInspectable var characterSpacing: CGFloat {
        get {
            // swiftlint:disable force_cast
            return attributedText?.value(forKey: NSAttributedString.Key.kern.rawValue) as! CGFloat
            // swiftlint:enable force_cast
        }
        set {
            if let labelText = text, labelText.count > 0 {
                let attributedString = NSMutableAttributedString(attributedString: attributedText!)
                attributedString.addAttribute(
                    NSAttributedString.Key.kern,
                    value: newValue,
                    range: NSRange(location: 0, length: attributedString.length - 1)
                )
                attributedText = attributedString
            }
        }
    }
}
