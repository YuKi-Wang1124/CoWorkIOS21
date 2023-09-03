//
//  Product.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct PromotedProducts: Codable {
    let title: String
    let products: [Product]
}

struct SearchData: Codable {
    let data: [SearchProduct]
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let colors: [Color]
    let sizes: [String]
    let variants: [Variant]
    let mainImage: String
    let images: [String]

    var size: String {
        return (sizes.first ?? "") + " - " + (sizes.last ?? "")
    }

    var stock: Int {
        return variants.reduce(0, { (previousData, upcomingData) -> Int in
            return previousData + upcomingData.stock
        })
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images
    }
}

struct Color: Codable {
    let name: String
    let code: String
}

struct Variant: Codable {
    let colorCode: String
    let size: String
    let stock: Int

    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size
        case stock
    }
}



struct SearchProduct: Codable {
    let category: String
    let colors: [Color]
    let description: String
    let id: String
    let images: [String]
    let mainImage: String
    let note: String
    let place: String
    let price: Int
    let sizes: [String]
    let source: String
    let story: String
    let texture: String
    let title: String
    let variants: [Variant]
    let wash: String
    
    enum CodingKeys: String, CodingKey {
        case category
        case colors
        case description
        case id
        case images
        case mainImage = "main_image"
        case note
        case place
        case price
        case sizes
        case source
        case story
        case texture
        case title
        case variants
        case wash
    }
}



