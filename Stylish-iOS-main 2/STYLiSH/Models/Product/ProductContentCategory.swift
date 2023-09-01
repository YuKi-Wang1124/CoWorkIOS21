//
//  ProductContentCategory.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/6.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

enum ProductContentCategory: String {
    case description = ""
    case color = "顏色"
    case size = "尺寸"
    case stock = "庫存"
    case texture = "材質"
    case washing = "洗滌"
    case placeOfProduction = "產地"
    case remarks = "備註"

    func identifier() -> String {
        switch self {
        case .description: return String(describing: ProductDescriptionTableViewCell.self)
        case .color: return ProductDetailCell.color
        case .size, .stock, .texture, .washing, .placeOfProduction, .remarks: return ProductDetailCell.label
        }
    }

    func cellForIndexPath(_ indexPath: IndexPath, tableView: UITableView, data: Product) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(), for: indexPath)
        guard let basicCell = cell as? ProductBasicCell else { return cell }
        switch self {
        case .description:
            basicCell.layoutCell(product: data)
        case .color:
            basicCell.layoutCellWithColors(category: rawValue, colors: data.colors.map { $0.code })
        case .size:
            basicCell.layoutCell(category: rawValue, content: data.size)
        case .stock:
            basicCell.layoutCell(category: rawValue, content: String(data.stock))
        case .texture:
            basicCell.layoutCell(category: rawValue, content: data.texture)
        case .washing:
            basicCell.layoutCell(category: rawValue, content: data.wash)
        case .placeOfProduction:
            basicCell.layoutCell(category: rawValue, content: data.place)
        case .remarks:
            basicCell.layoutCell(category: rawValue, content: data.note)
        }
        return basicCell
    }
}
