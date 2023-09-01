//
//  BasicSelectionCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/4.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol SelectionCellDataSource: AnyObject {
    func numberOfItem(_ cell: BasicSelectionCell) -> Int
    func viewIn(_ cell: BasicSelectionCell, selectionCell: SelectionCell, indexPath: IndexPath)
    func didSelected(_ cell: BasicSelectionCell, at indexPath: IndexPath)
}

class BasicSelectionCell: UITableViewCell,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    SelectionCellDataSource {

    lazy var collectionView: UICollectionView = {
        let layoutObject = UICollectionViewFlowLayout()
        layoutObject.itemSize = CGSize(width: 48, height: 48)
        layoutObject.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutObject.minimumLineSpacing = 16.0
        layoutObject.minimumInteritemSpacing = 0
        layoutObject.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutObject)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
//        addSubview(collectionView)
        insertSubview(collectionView, aboveSubview: contentView) // resolved temporally
//        contentView.addSubview(collectionView) //
        return collectionView
    }()

    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textColor = .B2
        label.font = .regular(size: 14)
        addSubview(label)
        return label
    }()

    weak var dataSource: SelectionCellDataSource?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        setupCollectionView()
        setupLabel()
        dataSource = self
        selectionStyle = .none
    }

    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 8.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        let bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        bottomConstraint.priority = .defaultHigh
        bottomConstraint.isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
        
        collectionView.register(SelectionCell.self, forCellWithReuseIdentifier: String(describing: SelectionCell.self))
    }

    private func setupLabel() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 24.0).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
    }

    func reloadData() {
        collectionView.reloadData()
    }

    // MARK: - SelectionCellDataSource. SubClass should override these data source method.
    func numberOfItem(_ cell: BasicSelectionCell) -> Int {
        return 0
    }

    func viewIn(_ cell: BasicSelectionCell, selectionCell: SelectionCell, indexPath: IndexPath) {}

    func didSelected(_ cell: BasicSelectionCell, at indexPath: IndexPath) {}

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItem(self) ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: SelectionCell.self),
            for: indexPath
        )
        guard let selectionCell = cell as? SelectionCell else { return cell }
        dataSource?.viewIn(self, selectionCell: selectionCell, indexPath: indexPath)
        return selectionCell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource?.didSelected(self, at: indexPath)
    }
}

class SelectionCell: UICollectionViewCell {

    var objectView: UIView! {
        didSet {
            stickSubView(objectView)
        }
    }
}
