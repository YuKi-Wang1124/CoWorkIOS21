//
//  OrderProvider.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

class OrderProvider {

    enum OrderInfo {
        case products
        case reciever
        case paymentInfo
        
        func title() -> String {
            switch self {
            case .products: return "結帳商品"
            case .reciever: return "收件資訊"
            case .paymentInfo: return "付款詳情"
            }
        }
    }
    
    let orderCustructor: [OrderInfo] = [.products, .reciever, .paymentInfo]
    
    let payments: [Payment] = [.cash, .credit]
    
    var order: Order
    
    init(order: Order) {
        self.order = order
    }
}
