//
//  STParser.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

struct STSuccessParser<T: Codable>: Codable {
    let data: T
    let paging: Int?
    
    enum CodingKeys: String, CodingKey {
        case data
        case paging = "next_paging"
    }
}

struct STFailureParser: Codable {
    let errorMessage: String
}
