//
//  ProfileManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/14.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

class ProfileManager {

    let orderGroup = ProfileGroup(
        title: NSLocalizedString("我的訂單"),
        action: ProfileSegue.segueAllOrder,
        items: [
            OrderItem.awaitingPayment,
            OrderItem.awaitingShipment,
            OrderItem.shipped,
            OrderItem.awaitingReview,
            OrderItem.exchange
        ]
    )

    let serviceGroup = ProfileGroup(
        title: NSLocalizedString("更多服務"),
        action: nil,
        items: [
            ServiceItem.collcetion,
            ServiceItem.notification,
            ServiceItem.refund,
            ServiceItem.address,
            ServiceItem.customService,
            ServiceItem.systomReport,
            ServiceItem.bindPhone,
            ServiceItem.setting
        ]
    )

    lazy var groups: [ProfileGroup] = [orderGroup, serviceGroup]
}
