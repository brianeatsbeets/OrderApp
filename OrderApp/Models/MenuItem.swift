//
//  MenuItem.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import Foundation

// This struct is a model for an item on the menu
struct MenuItem: Codable {
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: String
    var imageURL: URL
    
    // Provide global access to a NumberFormatter to apply currency formatting
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter
    }()
    
    // Manually list the CodingKeys to conform to the server's API/naming schema
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
}
