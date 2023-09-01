//
//  LobbyViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit


class LobbyViewController: STBaseViewController {

//    @IBOutlet weak var lobbyView: LobbyView! {
//        didSet {
//            lobbyView.delegate = self
//        }
//    }
//
//    private var datas: [PromotedProducts] = [] {
//        didSet {
//            lobbyView.reloadData()
//        }
//    }
    
    var lobbyGridView = LobbyGridView() {
        didSet {
            lobbyGridView.delegate = self
        }
    }

    private var datas: [Product] = [] {
        didSet {
            lobbyGridView.reloadData()
        }
    }

    private let marketProvider = MarketProvider()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("This is from May")
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
           print("Device ID: \(uuid)")
        } else {
           print("Unable to retrieve device ID.")
        }
        
        navigationItem.titleView = UIImageView(image: .asset(.Image_Logo02))
        
        //lobbyView.beginHeaderRefresh()
        
        setGridLayout()
        lobbyGridView.beginHeaderRefresh()
    }

    // MARK: - Action
    private func setGridLayout() {
        view.addSubview(lobbyGridView)
        lobbyGridView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lobbyGridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lobbyGridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lobbyGridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lobbyGridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchData() {
        marketProvider.fetchHots(completion: { [weak self] result in
            switch result {
            case .success(let hots):
                //self?.datas = products
                var productList: [Product] = []
                for hot in hots {
                    for product in hot.products {
                        productList.append(product)
                    }
                }
                self?.datas = productList
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
}

//extension LobbyViewController: LobbyViewDelegate {
//
//    func triggerRefresh(_ lobbyView: LobbyView) {
//        fetchData()
//    }
//
//    // MARK: - UITableViewDataSource and UITableViewDelegate
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return datas.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datas[section].products.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: String(describing: LobbyTableViewCell.self),
//            for: indexPath
//        )
//        guard let lobbyCell = cell as? LobbyTableViewCell else { return cell }
//        let product = datas[indexPath.section].products[indexPath.row]
//        if indexPath.row % 2 == 0 {
//            lobbyCell.singlePage(
//                img: product.mainImage,
//                title: product.title,
//                description: product.description
//            )
//        } else {
//            lobbyCell.multiplePages(
//                imgs: product.images,
//                title: product.title,
//                description: product.description
//            )
//        }
//        return lobbyCell
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 67.0 }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 258.0 }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.01 }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(
//                withIdentifier: String(describing: LobbyTableViewHeaderView.self)
//            ) as? LobbyTableViewHeaderView else {
//                return nil
//        }
//        headerView.titleLabel.text = datas[section].title
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard
//            let detailVC = UIStoryboard.product.instantiateViewController(
//                withIdentifier: String(describing: ProductDetailViewController.self)
//            ) as? ProductDetailViewController
//        else {
//            return
//        }
//        detailVC.product = datas[indexPath.section].products[indexPath.row]
//        show(detailVC, sender: nil)
//
//    }
//}

extension LobbyViewController: LobbyGridViewDelegate {
    func triggerRefresh(_ lobbyGridView: LobbyGridView) {
        fetchData()
    }
    // MARK: - UICOllectionViewDataSource and UICOllectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        guard
            let productCell = cell as? ProductCollectionViewCell
        else {
            return cell
        }
        
        let product = datas[indexPath.row]
        
        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price
        )
        
        return productCell
    }
}
