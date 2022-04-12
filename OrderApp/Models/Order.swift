//
//  Order.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import Foundation

// This struct is a model for an order of one or more menu items
struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
