//
//  LobbyGridViewController.swift
//  STYLiSH
//
//  Created by 李童 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class LobbyGridViewController: STBaseViewController {

    @IBOutlet weak var lobbyGridView: LobbyGridView! {
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
        
        lobbyGridView.beginHeaderRefresh()
    }

    // MARK: - Action
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

extension LobbyGridViewController: LobbyGridViewDelegate {
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

