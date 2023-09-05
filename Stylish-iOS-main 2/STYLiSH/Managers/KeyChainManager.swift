//
//  KeyChainManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/7.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import KeychainAccess
import FBSDKLoginKit

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
    
    func saveEmail() {
        let graphRequest = FBSDKLoginKit.GraphRequest(
            graphPath: "me",
            parameters: ["fields": "email, name"],
            tokenString: AccessToken.current?.tokenString,
            version: nil,
            httpMethod: .get
        )
        graphRequest.start { (connection, result, error) -> Void in
            if error == nil {
                guard let userDict = result as? [String: Any] else { return }
                if let email = userDict["email"] as? String {
                    UserDefaults.standard.set(email, forKey: "UserEmail")
                }
            } else {
                print("error \(error)")
            }
        }
    }
}
