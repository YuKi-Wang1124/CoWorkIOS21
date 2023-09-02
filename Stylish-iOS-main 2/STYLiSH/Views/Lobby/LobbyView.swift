//
//  LobbyView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/22.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

protocol LobbyViewDelegate: UITableViewDataSource, UITableViewDelegate {
    func triggerRefresh(_ lobbyView: LobbyView)
}

class LobbyView: UIView {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self.delegate
            tableView.delegate = self.delegate
        }
    }
    
    weak var delegate: LobbyViewDelegate? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.dataSource = self.delegate
            tableView.delegate = self.delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
    }
    // MARK: - Action
    
    func beginHeaderRefresh() {
        tableView.beginHeaderRefreshing()
    }
    
    func reloadData() {
        tableView.endHeaderRefreshing()
        tableView.reloadData()
    }
    
    // MARK: - Private Method
    private func setupTableView() {
        tableView.lk_registerCellWithNib(
            identifier: String(describing: LobbyTableViewCell.self),
            bundle: nil
        )
        
        tableView.register(
            LobbyTableViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: String(describing: LobbyTableViewHeaderView.self)
        )
        
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.delegate?.triggerRefresh(self)
        })
    }
}

// MARK: for grid view
protocol LobbyGridViewDelegate: UICollectionViewDataSource, UICollectionViewDelegate {
    func triggerRefresh(_ lobbyGridView: LobbyGridView)
}

class LobbyGridView: UIView {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self.delegate
            collectionView.delegate = self.delegate
        }
    }
    
    weak var delegate: LobbyGridViewDelegate? {
        didSet {
            guard let collectionView = collectionView else { return }
            collectionView.dataSource = self.delegate
            collectionView.delegate = self.delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    // MARK: - Action
    
    func beginHeaderRefresh() {
        collectionView.beginHeaderRefreshing()
    }
    
    func reloadData() {
        collectionView.endHeaderRefreshing()
        collectionView.reloadData()
    }
    
    // MARK: - Private Method
    private func setupCollectionView() {
        collectionView.lk_registerCellWithNib(
            identifier: String(describing: ProductCollectionViewCell.self),
            bundle: nil
        )
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(
            width: Int(164.0 / 375.0 * UIScreen.width),
            height: Int(164.0 / 375.0 * UIScreen.width * 308.0 / 164.0)
        )
        flowLayout.sectionInset = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 24.0
        collectionView.collectionViewLayout = flowLayout
        
        //addSubview(collectionView)
        
        collectionView.addRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.delegate?.triggerRefresh(self)
        })
        
    }
}
