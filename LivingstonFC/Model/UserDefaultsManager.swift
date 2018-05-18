//
//  UserDefaultsManager.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 08/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation
import JWT

class UserDefaultsManager {
    private static let defaults = UserDefaults.standard
    
    static func addApiKey(_ apiKey: String) {
        defaults.set(apiKey, forKey: "Authorization")
    }
    
    static func getApiKey() -> String? {
        return defaults.string(forKey: "Authorization")
    }
    
    static func addAccessToken(_ token: String) {
        defaults.set(token, forKey: "Access_token")
        let _ = canDecodeJTW()
    }
    
    static func getAccessToken() -> String? {
        return defaults.string(forKey: "Access_token")
    }
    private static let key = "LiviLions"
    
    static func isLoggedIn() -> Bool {
        return isValidJWT()
    }
    
    static func isFullMember() -> Bool {
        return defaults.value(forKey: "hasFullMembership") as! Bool
    }
    
    static func logOut() {
        defaults.removeObject(forKey: "Access_token")
        defaults.removeObject(forKey: "expiration")
        defaults.removeObject(forKey: "Authorization")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "isAdmin")
        defaults.removeObject(forKey: "hasFullMembership")
    }
    
    private static func isValidJWT(_ token: String = getAccessToken() ?? "") -> Bool{
        return canDecodeJTW(token)
    }
    
    private static func canDecodeJTW(_ token: String = getAccessToken() ?? "") -> Bool{
        do {
            let claims: ClaimSet = try JWT.decode(token, algorithm: .hs256(UserDefaultsManager.key.data(using: .utf8)!))
            decodeAndSaveClaims(claims)
            return true
        } catch {
            print("Failed to decode JWT: \(error)")
            return false
        }
    }
    
    private static func decodeAndSaveClaims(_ claims: ClaimSet) {
        if let expiration = claims.expiration?.timeIntervalSinceNow {
            let expirationInMinutes = expiration / 60
            defaults.set(expirationInMinutes, forKey: "expiration")
        }
        if let email = claims["email"] as? String {
            defaults.set(email, forKey: "email")
        }
        if let isAdmin = claims["admin"] as? Int {
            if isAdmin == 1 {
                defaults.set(true, forKey: "isAdmin")
            } else if isAdmin == 0 {
                defaults.set(false, forKey: "isAdmin")
            }
        }
        if let username = claims["username"] as? String {
            defaults.set(username, forKey: "username")
        }
        if let hasFullMembership = claims["full_membership"] as? Int {
            if hasFullMembership == 1 { //full membership user
                defaults.set(true, forKey: "hasFullMembership")
            } else if hasFullMembership == 0 { //partial membership == true
                defaults.set(false, forKey: "hasFullMembership")
            }
        }
    }
}
