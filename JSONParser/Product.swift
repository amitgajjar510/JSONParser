//
//  Product.swift
//  JSONParser
//
//  Created by doxper on 17/06/19.
//  Copyright © 2019 amitgajjar. All rights reserved.
//

import Foundation

class Product: Codable {
    // MARK: Properties
    var productId: String = ""
    var title: String?
    var price: String?
    var subCategory: String?
    var popularity: String?
    
    // MARK: Coding Keys enumerator
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case price = "price"
        case subCategory = "subcategory"
        case popularity = "popularity"
    }
}



