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
