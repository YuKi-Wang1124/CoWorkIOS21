//
//  ABTesting.swift
//  STYLiSH
//
//  Created by 李童 on 2023/9/3.
//  Copyright © 2023 AppWorks School. All rights reserved.
//
import FBSDKLoginKit

struct ABTest: Codable {
    var system: String = "iOS"
    var version: String = {
        var string = String()
        if UserDefaults.standard.bool(forKey: "IsGridLobby") {
            string = "grid"
        } else {
            string = "linear"
        }
        return string
    }()
    var event: String = String()
    var eventDetail: String = String()
    var userEmail: String = String()
    var deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""

    enum CodingKeys: String, CodingKey {
        case system, version, event
        case eventDetail = "event_detail"
        case userEmail = "user_email"
        case deviceID = "device_id"
    }
}

struct EventResponse: Codable {
    let status: String
}
