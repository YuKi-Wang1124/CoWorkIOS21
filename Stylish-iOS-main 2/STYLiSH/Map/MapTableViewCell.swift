//
//  MapTableViewCell.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit



class MapTableViewCell: UITableViewCell {
    
    var identifier = "MapTableViewCell"

    var storeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    var phoneNumberLabel: UnderlinedLabel = {
//        let label = UnderlinedLabel()
//        label.textColor = .systemBlue
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
    var phoneNumberBtn = {
        var btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var addressBtn = {
        var btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        contentView.backgroundColor = .white
        
//        deleteButton.addTarget(self, action: #selector(deleteCellByClosure(sender:)), for: .touchUpInside)
        
    }
    
    @objc func deleteCellByClosure(sender: UIButton) {
        // 1-1 closure
//        deleteCell?()
        
        // 1-3 delegate
//        delegate?.didTapDeleteButton(in: self)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storeNameLabel.text = nil
        phoneNumberBtn.setTitle("", for: .normal)
        addressBtn.setTitle("", for: .normal)
    }

    private func setupUI() {
        
        contentView.addSubview(storeNameLabel)
        contentView.addSubview(phoneNumberBtn)
        contentView.addSubview(addressBtn)
                
        NSLayoutConstraint.activate([
            storeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            storeNameLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            phoneNumberBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            phoneNumberBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            phoneNumberBtn.centerYAnchor.constraint(equalTo: storeNameLabel.bottomAnchor, constant: 20),
            
            addressBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addressBtn.centerYAnchor.constraint(equalTo: phoneNumberBtn.bottomAnchor, constant: 20),
            addressBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}


class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        }
    }
}

class MyButton : UIButton {
    var title = ""
}
