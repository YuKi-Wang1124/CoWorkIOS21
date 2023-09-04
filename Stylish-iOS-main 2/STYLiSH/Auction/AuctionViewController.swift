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
    
    var timer: Timer?
    
    var marqueeIndex = 0
    
    @IBOutlet weak var marqueeLabel: UILabel!
    
    var marqueeTitleArray = ["冬季新品洋裝拍賣中      ", "夏季新品洋裝拍賣中      "]
    
    @IBOutlet weak var auctionTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auctionTableView.dataSource = self
        auctionTableView.delegate = self

        marqueeLabel.text = marqueeTitleArray[marqueeIndex]

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
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    
                    print("Get string: \(message)")
                    
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error)")
            }
            
            self?.receive()
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            
            timer?.invalidate()
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

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did connect to socket")
        ping()
        receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection with reason: \(String(describing: reason))")

    }
}


protocol ReceieveWebSocketDelegate {
    
    func receiveWebsocketData(text: String)
    
}


extension AuctionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = auctionTableView.dequeueReusableCell(withIdentifier: AuctionTableViewCell.identifier) as? AuctionTableViewCell
        
        cell?.addPriceBtn.addTarget(self, action: #selector(addPriceBtn), for: .touchUpInside)
        
        return cell ?? UITableViewCell()
    }
    
    @objc func addPriceBtn() {
        send()
        
        print("ZZZZZZZZ")
    }
}

