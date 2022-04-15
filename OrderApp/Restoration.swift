//
//  Restoration.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/14/22.
//

import Foundation

// This extension of NSUserActivity provides an Order property that is encoded and decoded upon get/set
extension NSUserActivity {
    
    // The user's current order
    var order: Order? {
        
        // Decode the order data
        get {
            guard let jsonData = userInfo?["order"] as? Data else { return nil }
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        
        // Encode the order data
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
    
    // The user's currently presented view controller
    var controllerIdentifier: StateRestorationController.Identifier? {
        
        // Fetch the controllerIdentifier data
        get {
            if let controllerIdentifier = userInfo?["controllerIdentifier"] as? String {
                return StateRestorationController.Identifier(rawValue: controllerIdentifier)
            } else {
                return nil
            }
        }
        
        // Set the controllerIdentifier data
        set {
            userInfo?["controllerIdentifier"] = newValue?.rawValue
        }
    }
    
    // The user's currently selected menu category
    var menuCategory: String? {
        
        // Fetch the menuCategory data
        get {
            return userInfo?["menuCategory"] as? String
        }
        
        // Set the menuCategory data
        set {
            userInfo?["menuCategory"] = newValue
        }
    }
    
    // The user's currently selected menu item
    var menuItem: MenuItem? {
        
        // Decode the menuItem data
        get {
            guard let jsonData = userInfo?["menuItem"] as? Data else { return nil }
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
        }
        
        // Encode the data
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["menuItem": jsonData])
            } else {
                userInfo?["menuItem"] = nil
            }
        }
    }
}

// This enum contains the possible state restoration views to be restored
enum StateRestorationController {
    
    // This enum provides options for the view currently in use
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    // Keep track of the view currently in use
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .menuItemDetail: return Identifier.menuItemDetail
        case .order: return Identifier.order
        }
    }
}
