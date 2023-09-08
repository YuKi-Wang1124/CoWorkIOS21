//
//  LobbyCompondViewController.swift
//  STYLiSH
//
//  Created by 李童 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

//import UIKit
//
//class LobbyCompoundViewController: STCompondViewController {
//
//    @IBOutlet weak var lobbyView: LobbyView! {
//        didSet {
//            lobbyView.delegate = self
//        }
//    }
//
//    private var datas: [[PromotedProducts]] = [[]] {
//        didSet {
//            lobbyView.reloadData()
//        }
//    }
//
//    private let marketProvider = MarketProvider()
//
//    // MARK: - View Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.titleView = UIImageView(image: .asset(.Image_Logo02))
//
//        lobbyView.beginHeaderRefresh()
//    }
//
//    // MARK: - Action
//    private func fetchData() {
//        marketProvider.fetchHots(completion: { [weak self] result in
//            switch result {
//            case .success(let products):
//                self?.datas[0] = products
//            case .failure:
//                LKProgressHUD.showFailure(text: "讀取資料失敗！")
//            }
//        })
//    }
//}
//
//extension LobbyCompoundViewController: LobbyViewDelegate {
//
//    func triggerRefresh(_ lobbyView: LobbyView) {
//        fetchData()
//    }
//
//    // MARK: - UITableViewDataSource and UITableViewDelegate
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return datas[0].count
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
////        let url = URL(string: "http://54.66.145.204:8000/get_headers")!
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
////        let encoder = JSONEncoder()
////        let user = CreateUserBody(name: "Peter", job: "情歌王子")
////        let data = try? encoder.encode(user)
////        request.httpBody = data
////
////        URLSession.shared.dataTask(with: request) { data, response, error in
////            print("response: ", response)
////            if let data {
////                do {
////                    print(data)
////                    let decoder = JSONDecoder()
////                    let createUserResponse = try decoder.decode(CreateUserResponse.self, from: data)
////                    print(createUserResponse)
////                } catch  {
////                    print(error)
////                }
////            }
////        }.resume()
//
//    }
//}

