//
//  ABTesting.swift
//  STYLiSH
//
//  Created by 李童 on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

struct ABTest: Codable {
    var system: String = "iOS"
    var version: String = String()
    var event: String = String()
    var eventDetail: String = String()
    var userEmail: String?
    var deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var createdTime: Date = Date()

    enum CodingKeys: String, CodingKey {
        case system, version, event
        case eventDetail = "event_detail"
        case userEmail = "user_email"
        case deviceID = "device_id"
        case createdTime = "created_time"
    }
}
