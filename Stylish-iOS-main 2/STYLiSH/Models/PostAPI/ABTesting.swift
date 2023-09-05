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
    var category: String = String()
    var event: String = String()
    var eventDetail: String = String()
    var userEmail: String = UserDefaults.standard.string(forKey: "UserEmail") ?? ""
    var userID: String = UserDefaults.standard.string(forKey: "DeviceID") ?? "invalid ID"

    enum CodingKeys: String, CodingKey {
        case system, version, category, event
        case eventDetail = "event_detail"
        case userEmail = "user_email"
        case userID = "user_id"
    }
}

struct EventResponse: Codable {
    let status: String
}

enum Event: String {
    case viewItem = "view_item"
    case addToCart = "add_to_cart"
    case checkout = "checkout"
}
