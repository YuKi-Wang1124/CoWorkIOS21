//
//  AuctionViewController.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class AuctionViewController: UIViewController {
    
    private var webSocket: URLSessionWebSocketTask?
    
    private var auctionDataArray = [AuctionProductData]()
    
    private var titleArray = [String]()
    private var priceArray = [String]()
    private var imageArray = [String]()
    private var minBidUnit = [String]()
    private var timeArray = [String]()

    var timer: Timer?
    
    var marqueeIndex = 0
    
    var cellCount = 0
    
    @IBOutlet weak var marqueeLabel: UILabel!
    
    var marqueeTitleArray = [String]()
    
    @IBOutlet weak var auctionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.title = "拍賣"
        fetchAuctionProducts()
        auctionTableView.dataSource = self
        auctionTableView.delegate = self

        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())

        let url = URL(string: "ws://3.24.100.29:9000/api/1.0/update_bid")
        guard let url = url else { return }
        
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.nextTitle()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    func ping() {
        webSocket?.sendPing { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        }
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
    }
    
    func send() {
        let jsonDictionary: [String: Any] = [
            "type": "bid_increment",
            "number": 100
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            
            webSocket?.send(.data(data)) { error in
                if let error = error {
                    print("Send error: \(error)")
                }
            }
        } catch {
            print("JSON serialization error: \(error)")
        }
    }
    
    func receive() {
        var messages: String?
        
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    
                    print("Get string: \(message)")
                    messages = message
                    
                    
                    // MARK: delegate priceArray 更新
                    if let data = message.data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let changePrice = try decoder.decode(ChangePrice.self, from: data)
                            let newPrice = changePrice.number
                            self?.priceArray[0] = String(newPrice)
                            print(self?.priceArray)
                            DispatchQueue.main.async {
                                self?.auctionTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error)")
            }
            self?.receive()
        })
        
        if let messages = messages {
            print(priceArray)
            let messengeDict = convertToDictionary(text: messages)
            priceArray[0] = messengeDict?["number"] as? String ?? "price error"
            auctionTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func nextTitle() {
        marqueeIndex = (marqueeIndex + 1) % marqueeTitleArray.count
        let transition = CATransition()
        transition.duration = 0.8
        transition.type = .push
        transition.subtype = .fromRight
        marqueeLabel.text = marqueeTitleArray[marqueeIndex]
        marqueeLabel.layer.add(transition, forKey: "nextTitle")
    }
}

extension AuctionViewController: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        print("Did connect to socket")
        ping()
        receive()
    }

    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        print("Did close connection with reason: \(String(describing: reason))")
    }
}

protocol ReceieveWebSocketDelegate {
    func receiveWebsocketData(text: String)
}

extension AuctionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = auctionTableView.dequeueReusableCell(
            withIdentifier: AuctionTableViewCell.identifier) as? AuctionTableViewCell
        
        cell?.addPriceBtn.setTitle("+ " + minBidUnit[indexPath.row], for: .normal)
        cell?.timeLabel.text = timeArray[indexPath.row]
        cell?.productLabel.text = titleArray[indexPath.row]
        cell?.priceLabel.text = "NTD " + priceArray[indexPath.row]
        cell?.productImageView.loadImage(imageArray[indexPath.row],
                                         placeHolder: UIImage(imageLiteralResourceName: "Image_Placeholder"))
        cell?.addPriceBtn.addTarget(self, action: #selector(addPriceBtn), for: .touchUpInside)
        
        return cell ?? UITableViewCell()
    }
    
    @objc func addPriceBtn() {
        send()
        print("ZZZZZZZZ")
    }
    
    private func fetchAuctionProducts() {
        
        let url = "http://3.24.100.29/api/1.0/auction/product"
        
        guard let url = URL(string: url) else {
            print("no url")
            return
        }
        
        var request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let product = try JSONDecoder().decode(AuctionProductData.self, from: data)
                    self.auctionDataArray.removeAll()
                    
                    self.auctionDataArray.append(product)
                    
                    print(self.auctionDataArray.first?.data)
                    
                    self.auctionDataArray.first?.data.forEach {
                        self.marqueeTitleArray.append($0.title + "拍賣中" + "            " )
                        self.titleArray.append($0.title)
                        self.imageArray.append($0.mainImage)
                        self.minBidUnit.append(String($0.minBidUnit))
                        self.priceArray.append(String($0.startBid))
                        
                        let timestamp = $0.endTime
                        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale.current
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .medium
                        let localTime = dateFormatter.string(from: date)
                        self.timeArray.append(localTime)
                    }
                    
                    self.cellCount = self.titleArray.count
                    
                    DispatchQueue.main.async {
                        self.marqueeLabel.text = self.marqueeTitleArray[self.marqueeIndex]
                        self.auctionTableView.reloadData()
                    }

                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}



struct AuctionProductData: Codable {
    let data: [AuctionProduct]
}

struct AuctionProduct: Codable {
//    let category: String
//    let description: String
    let endTime: Int
//    let id: String
//    let imageBase64: String?
//    let images: String
    let mainImage: String
    let minBidUnit: Int
//    let note: String
//    let place: String
    let startBid: Int
//    let source: String
//    let story: String
//    let texture: String
    let title: String
//    let wash: String

    enum CodingKeys: String, CodingKey {
//        case category
//        case description
        case endTime = "end_time"
//        case id
//        case imageBase64 = "image_base64"
//        case images
        case mainImage = "main_image"
        case minBidUnit = "min_bid_unit"
//        case note
//        case place
        case startBid = "start_bid"
//        case source
//        case story
//        case texture
        case title
//        case wash
    }
}

struct ChangePrice: Codable {
    var type: String = String()
    var number: Int = Int()
}
