//
//  File.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class MapTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "\(MapTableViewHeaderFooterView.self)"
    
    var sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContents()
    }
    
    func configureContents() {
        contentView.backgroundColor = .white
        contentView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 4),
            sectionLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8)
        ])
    }
}
