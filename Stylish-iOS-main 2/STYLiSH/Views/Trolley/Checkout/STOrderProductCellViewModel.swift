//
//  STOrderProductCellViewModel.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/8/9.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct STOrderProductCellViewModel {
    let imageUrl: String?
    let title: String?
    let color: String?
    let size: String?
    let price: String?
    let pieces: String?
    
    init(order: LSOrder) {
        imageUrl = order.product?.images?[0]
        title = order.product?.title
        color = order.selectedColor?.code
        size = order.seletedSize
        price = String(order.product!.price)
        pieces = String(order.amount)
    }
}
