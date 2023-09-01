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
