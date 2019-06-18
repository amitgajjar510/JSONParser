//
//  ProductList.swift
//  JSONParser
//
//  Created by doxper on 17/06/19.
//  Copyright © 2019 amitgajjar. All rights reserved.
//

import Foundation

class ProductList: Codable {
    // MARK: Properties
    var count: Int32?
    var productsDictionary: [String: [String: String]]?
    var products: [Product] = []
    
    // MARK: Coding Keys enumerator
    private enum CodingKeys: String, CodingKey {
        case count = "count"
        case productsDictionary = "products"
    }
    
    // MARK: Internal Methods
    internal func updateProducts() {
        productsDictionary?.forEach({ (key, value) in
            if let data = try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted), let product = try? JSONDecoder().decode(Product .self, from: data) {
                product.productId = key
                products.append(product)
            }
        })
    }
    
    internal func sortProducts(withSortByOption sortBy: SortBy) {
        switch sortBy {
        case .popularityHighToLow:
            products.sort { (productOne, productTwo) -> Bool in
                let productOnePopularity = Int32(productOne.popularity ?? "") ?? 0
                let productTwoPopularity = Int32(productTwo.popularity ?? "") ?? 0
                return productOnePopularity > productTwoPopularity
            }
        case .popularityLowToHigh:
            products.sort { (productOne, productTwo) -> Bool in
                let productOnePopularity = Int32(productOne.popularity ?? "") ?? 0
                let productTwoPopularity = Int32(productTwo.popularity ?? "") ?? 0
                return productOnePopularity < productTwoPopularity
            }
        case .priceLowToHigh:
            products.sort { (productOne, productTwo) -> Bool in
                let productOnePrice = Int32(productOne.price ?? "") ?? 0
                let productTwoPrice = Int32(productTwo.price ?? "") ?? 0
                return productOnePrice < productTwoPrice
            }
        case .priceHighToLow:
            products.sort { (productOne, productTwo) -> Bool in
                let productOnePrice = Int32(productOne.price ?? "") ?? 0
                let productTwoPrice = Int32(productTwo.price ?? "") ?? 0
                return productOnePrice > productTwoPrice
            }
        }
    }
}
