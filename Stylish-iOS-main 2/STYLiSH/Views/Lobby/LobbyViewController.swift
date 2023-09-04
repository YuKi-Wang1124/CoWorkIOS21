//
//  LobbyViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class LobbyViewController: STBaseViewController {

    @IBOutlet weak var lobbyView: LobbyView! {
        didSet {
            lobbyView.delegate = self
        }
    }

    private var datas: [PromotedProducts] = [] {
        didSet {
            lobbyView.reloadData()
        }
    }
    
    @IBOutlet weak var lobbyGridView: LobbyGridView! {
        didSet {
            lobbyGridView.delegate = self
        }
    }

    private var datasGird: [Product] = [] {
        didSet {
            lobbyGridView.reloadData()
        }
    }

    private let marketProvider = MarketProvider()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: .asset(.Image_Logo02))
        
        if UserDefaults.standard.bool(forKey: "IsGridLobby") {
            lobbyGridView.beginHeaderRefresh()
            lobbyView.isHidden = true
        } else {
            lobbyView.beginHeaderRefresh()
            lobbyGridView.isHidden = true
        }
    }

    // MARK: - Action
    
    private func fetchData() {
        marketProvider.fetchHots(completion: { [weak self] result in
            switch result {
            case .success(let hots):
                if UserDefaults.standard.bool(forKey: "IsGridLobby") { // collection view
                    var productList: [Product] = []
                    for hot in hots {
                        for product in hot.products {
                            productList.append(product)
                        }
                    }
                    self?.datasGird = productList
                } else {
                    self?.datas = hots
                }
            case .failure:
                LKProgressHUD.showFailure(text: "讀取資料失敗！")
            }
        })
    }
}

extension LobbyViewController: LobbyViewDelegate {

    func triggerRefresh(_ lobbyView: LobbyView) {
        fetchData()
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[section].products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: LobbyTableViewCell.self),
            for: indexPath
        )
        guard let lobbyCell = cell as? LobbyTableViewCell else { return cell }
        let product = datas[indexPath.section].products[indexPath.row]
        if indexPath.row % 2 == 0 {
            lobbyCell.singlePage(
                img: product.mainImage,
                title: product.title,
                description: product.description
            )
        } else {
            lobbyCell.multiplePages(
                imgs: product.images,
                title: product.title,
                description: product.description
            )
        }
        return lobbyCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 67.0 }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 258.0 }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.01 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: String(describing: LobbyTableViewHeaderView.self)
            ) as? LobbyTableViewHeaderView else {
                return nil
        }
        headerView.titleLabel.text = datas[section].title
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let detailVC = UIStoryboard.product.instantiateViewController(
                withIdentifier: String(describing: ProductDetailViewController.self)
            ) as? ProductDetailViewController
        else {
            return
        }
        detailVC.product = datas[indexPath.section].products[indexPath.row]
        show(detailVC, sender: nil)
        
        // MARK: post API
        let url = URL(string: "http://3.24.100.29/api/1.0/user/event")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        
        var abTestData: ABTest = ABTest()
        abTestData.event = Event.viewItem.rawValue
        abTestData.eventDetail = String(datas[indexPath.section].products[indexPath.row].id)
        abTestData.userEmail = UserDefaults.standard.string(forKey: "UserEmail") ?? ""

        let body = try? encoder.encode(abTestData)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(EventResponse.self, from: data)
                    print(createUserResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}

extension LobbyViewController: LobbyGridViewDelegate {
    func triggerRefresh(_ lobbyGridView: LobbyGridView) {
        fetchData()
    }
    // MARK: - UICOllectionViewDataSource and UICOllectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasGird.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath
        )
        guard
            let productCell = cell as? ProductCollectionViewCell
        else {
            return cell
        }
        
        let product = datasGird[indexPath.row]
        
        productCell.layoutCell(
            image: product.mainImage,
            title: product.title,
            price: product.price
        )
        
        return productCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let product = datasGird[indexPath.row]
        showProductDetailViewController(product: product)
        
        // MARK: post API
        let url = URL(string: "http://3.24.100.29/api/1.0/user/event")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        
        var abTestData: ABTest = ABTest()
        abTestData.event = Event.viewItem.rawValue
        abTestData.eventDetail = String(product.id)
        abTestData.userEmail = UserDefaults.standard.string(forKey: "UserEmail") ?? ""
        print(abTestData)

        let body = try? encoder.encode(abTestData)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let decoder = JSONDecoder()
                    let createUserResponse = try decoder.decode(EventResponse.self, from: data)
                    print(createUserResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    private func showProductDetailViewController(product: Product) {
        let productDetailVC = UIStoryboard.product.instantiateViewController(withIdentifier:
            String(describing: ProductDetailViewController.self)
        )
        guard let detailVC = productDetailVC as? ProductDetailViewController else { return }
        detailVC.product = product
        show(detailVC, sender: nil)
    }
}

enum Event: String {
    case viewItem = "view_item"
    case addToCart = "add_to_cart"
    case checkout = "checkout"
}
