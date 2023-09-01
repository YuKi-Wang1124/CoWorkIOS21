//
//  LSColor+Extension.swift
//  STYLiSH
//
//  Created by Wayne Chen on 2021/4/21.
//  Copyright © 2021 WU CHIH WEI. All rights reserved.
//

import Foundation

extension LSColor {
    
    func toColor() -> Color? {
        if let code = code, let name = name {
            return Color(name: name, code: code)
        }
        return nil
    }
}
