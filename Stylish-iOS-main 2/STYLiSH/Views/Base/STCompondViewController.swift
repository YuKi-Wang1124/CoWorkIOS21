//
//  STCompondViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/2.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class STCompondViewController: STBaseViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var datas: [[Any]] = [[]] {
        didSet {
            reloadData()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cpdSetupTableView()
        cpdSetupCollectionView()

        tableView.beginHeaderRefreshing()
    }

    // MARK: - Private Method
    private func cpdSetupTableView() {
        if tableView == nil {
            let tableView = UITableView()
            view.stickSubView(tableView)
            self.tableView = tableView
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.headerLoader()
        })
        tableView.addRefreshFooter(refreshingBlock: { [weak self] in
            self?.footerLoader()
        })
    }

    private func cpdSetupCollectionView() {
        if collectionView == nil {
            let collectionView = UICollectionView(
                frame: CGRect.zero,
                collectionViewLayout: UICollectionViewFlowLayout()
            )
            view.stickSubView(collectionView)
            self.collectionView = collectionView
        }

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.headerLoader()
        })
        collectionView.addRefreshFooter(refreshingBlock: { [weak self] in
            self?.footerLoader()
        })
    }

    // MARK: - Public Method: Manipulate table view and collection view
    private func reloadData() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
            return
        }
        tableView.reloadData()
        collectionView.reloadData()
    }

    func headerLoader() {
        tableView.endHeaderRefreshing()
        collectionView.endHeaderRefreshing()
    }

    func footerLoader() {
        tableView.endFooterRefreshing()
        collectionView.endFooterRefreshing()
    }

    func endHeaderRefreshing() {
        tableView.endHeaderRefreshing()
        collectionView.endHeaderRefreshing()
    }

    func endFooterRefreshing() {
        tableView.endFooterRefreshing()
        collectionView.endFooterRefreshing()
    }

    func endWithNoMoreData() {
        tableView.endWithNoMoreData()
        collectionView.endWithNoMoreData()
    }

    func resetNoMoreData() {
        tableView.resetNoMoreData()
        collectionView.resetNoMoreData()
    }

    // MARK: - Public Method: Change layout
    func showGridView() {
        collectionView.isHidden = false
        tableView.isHidden = true

        guard let indexPaths = tableView.indexPathsForVisibleRows else { return }
        let sortedResult = indexPaths.sorted(by: { $0.row < $1.row })
        guard let minIndexPath = sortedResult.first else { return }
        collectionView.scrollToItem(at: minIndexPath, at: .top, animated: false)
    }

    func showListView() {
        collectionView.isHidden = true
        tableView.isHidden = false
        let sortedResult = collectionView.indexPathsForVisibleItems.sorted(by: { $0.row < $1.row })
        guard let minIndexPath = sortedResult.first else { return }
        tableView.scrollToRow(at: minIndexPath, at: .top, animated: false)
    }

    // MARK: - UITableViewDataSource. Subclass should override these method for setting properly.
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: String(describing: STCompondViewController.self))
    }

    // MARK: - UICollectionViewDataSource. Subclass should override these method for setting properly.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
