//
//  KeyChainManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import KeychainAccess

class KeyChainManager {

    static let shared = KeyChainManager()

    private let service: Keychain

    private let serverTokenKey: String = "STYLiSHToken"

    private init() {
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }

    var token: String? {
        get {
            guard let serverKey = UserDefaults.standard.string(forKey: serverTokenKey) else { return nil }
            for item in service.allItems() {
                if let key = item["key"] as? String, key == serverKey {
                    return item["value"] as? String
                }
            }
            return nil
        }
        set {
            guard let uuid = UserDefaults.standard.value(forKey: serverTokenKey) as? String else {
                let uuid = UUID().uuidString
                UserDefaults.standard.set(uuid, forKey: serverTokenKey)
                service[uuid] = newValue
                return
            }
            service[uuid] = newValue
        }
    }
}
