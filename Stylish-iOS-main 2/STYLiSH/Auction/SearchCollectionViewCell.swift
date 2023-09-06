//
//  SearchCollectionViewCell.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/2.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "\(SearchCollectionViewCell.self)"
    
    private let view = UIView()
    
    var imageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageLiteralResourceName: "Image_Placeholder")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    var productNameLabel = {
        let label = UILabel()
        label.textColor = UIColor.B1
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "厚實毛呢格子外套"
        return label
    }()
    
    var priceLabel = {
        let label = UILabel()
        label.textColor = UIColor.B1
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "NT$2140"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        view.addSubview(imageView)
        view.addSubview(productNameLabel)
        view.addSubview(priceLabel)

        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            imageView.topAnchor.constraint(equalTo: view.topAnchor,constant: 18),
            imageView.heightAnchor.constraint(equalToConstant: 230),

            productNameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),

            priceLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productNameLabel.text = nil
    }
}
