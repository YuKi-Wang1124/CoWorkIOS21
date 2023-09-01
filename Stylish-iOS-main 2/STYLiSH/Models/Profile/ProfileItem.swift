//
//  ProfileItem.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol ProfileItem {
    var image: UIImage? { get }
    var title: String { get }
}

enum ProfileSegue: String {
    case segueAllOrder = "AllOrder"

    var title: String {
        switch self {
        case .segueAllOrder: return NSLocalizedString("查看全部")
        }
    }
}

struct ProfileGroup {
    let title: String
    let action: ProfileSegue?
    let items: [ProfileItem]
}

enum OrderItem: ProfileItem {
    case awaitingPayment
    case awaitingShipment
    case shipped
    case awaitingReview
    case exchange

    var image: UIImage? {
        switch self {
        case .awaitingPayment: return .asset(.Icons_24px_AwaitingPayment)
        case .awaitingShipment: return .asset(.Icons_24px_AwaitingShipment)
        case .shipped: return .asset(.Icons_24px_Shipped)
        case .awaitingReview: return .asset(.Icons_24px_AwaitingReview)
        case .exchange: return .asset(.Icons_24px_Exchange)
        }
    }

    var title: String {
        switch self {
        case .awaitingPayment: return NSLocalizedString("待付款")
        case .awaitingShipment: return NSLocalizedString("待出貨")
        case .shipped: return NSLocalizedString("待簽收")
        case .awaitingReview: return NSLocalizedString("待評價")
        case .exchange: return NSLocalizedString("退換貨")
        }
    }
}

enum ServiceItem: ProfileItem {
    case collcetion
    case notification
    case refund
    case address
    case customService
    case systomReport
    case bindPhone
    case setting

    var image: UIImage? {
        switch self {
        case .collcetion: return .asset(.Icons_24px_Starred)
        case .notification: return .asset(.Icons_24px_Notification)
        case .refund: return .asset(.Icons_24px_Refunded)
        case .address: return .asset(.Icons_24px_Address)
        case .customService: return .asset(.Icons_24px_CustomerService)
        case .systomReport: return .asset(.Icons_24px_SystemFeedback)
        case .bindPhone: return .asset(.Icons_24px_RegisterCellphone)
        case .setting: return .asset(.Icons_24px_Settings)
        }
    }

    var title: String {
        switch self {
        case .collcetion: return NSLocalizedString("收藏")
        case .notification: return NSLocalizedString("貨到通知")
        case .refund: return NSLocalizedString("帳戶退款")
        case .address: return NSLocalizedString("地址")
        case .customService: return NSLocalizedString("客服訊息")
        case .systomReport: return NSLocalizedString("系統回饋")
        case .bindPhone: return NSLocalizedString("手機綁定")
        case .setting: return NSLocalizedString("設定")
        }
    }
}
