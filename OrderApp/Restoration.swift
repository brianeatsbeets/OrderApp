//
//  Restoration.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/14/22.
//

import Foundation

// This extension of NSUserActivity provides an Order property that is encoded and decoded upon get/set
extension NSUserActivity {
    
    var order: Order? {
        
        // Decode the data
        get {
            guard let jsonData = userInfo?["order"] as? Data else { return nil }
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        
        // Encode the data
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
}
