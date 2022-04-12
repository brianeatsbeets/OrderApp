//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Aguirre, Brian P. on 4/4/22.
//

import Foundation

// This struct is a model for an API response when requesting menu items from a specific category
struct MenuResponse: Codable {
    let items: [MenuItem]
}

// This struct is a model for an API response when requesting the menu categories
struct CategoriesResponse: Codable {
    let categories: [String]
}

// This struct is a model for an API response when submitting an order
struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
