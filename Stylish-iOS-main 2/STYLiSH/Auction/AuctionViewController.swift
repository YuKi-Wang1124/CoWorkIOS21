//
//  AuctionViewController.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import UserNotifications

class AuctionViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    private var webSocket: URLSessionWebSocketTask?
    
    private var auctionDataArray = [AuctionProductData]()
    private var titleArray = [String]()
    private var priceArray = [String]()
    private var imageArray = [String]()
    private var minBidUnit = [String]()
    var marqueeTitleArray = [String]()
    private var timeDiffArray = [Int]()
    private var startTimeArray = [TimeInterval]()
    private var endTimeArray = [TimeInterval]()

    var timer: Timer?
    var marqueeIndex = 0
    var cellCount = 0
    
    @IBOutlet weak var marqueeLabel: UILabel!
    @IBOutlet weak var auctionTableView: UITableView!
    
    var totalAddAmount = 0
    //var updatePriceIndex = 1
    
    let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    
    // 若競標成功就給值
    var auctionSuccessPrice: Int?
    var auctionEnd = false
    
    var emailHere = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //successNotificationContent()
        UNUserNotificationCenter.current().delegate = self
        
        let uuid = UUID()
        emailHere = uuid.uuidString.lowercased()
        
        DispatchQueue.main.async {
            self.dispatchSemaphore.wait()
            self.fetchAuctionProducts()
            
            self.dispatchSemaphore.wait()
            self.auctionTableView.dataSource = self
            self.dispatchSemaphore.signal()
            
            self.auctionTableView.allowsSelection = false
            self.auctionTableView.delegate = self
            
            let session = URLSession(configuration: .default,
                                     delegate: self,
                                     delegateQueue: OperationQueue())

            let url = URL(string: "ws://3.24.100.29:9000/api/1.0/update_bid")
            guard let url = url else { return }
            
            self.webSocket = session.webSocketTask(with: url)
            self.webSocket?.resume()
            
            self.dispatchSemaphore.wait()
            self.fetchLatestPrice()
        }
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
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
    
    func sendBid(addAmount: Int) {
        let jsonDictionary: [String: Any] = [
            "type": "bid_increment",
            "data": [
                "number": addAmount,
                "email": emailHere
            ] as [String: Any]
        ]
        
        do {
            let topData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            webSocket?.send(.data(topData)) { error in
                if let error = error {
                    print("Send error: \(error)")
                }
            }
        } catch {
            print("send bid Data JSON serialization error: \(error)")
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
                    
                    // MARK: delegate priceArray 更新
                    if let message = message.data(using: .utf8) {
                        do {
                            let decoder = JSONDecoder()
                            let topData = try decoder.decode(TopData.self, from: message)
                            
                            // 2nd decoder
                            if topData.type == "latest_price" {
                                do {
                                    let decoder = JSONDecoder()
                                    let data = try decoder.decode(LatestPriceData.self, from: message)
                                    let newPrice = data.data.number
                                    self?.priceArray[0] = String(newPrice)
                                    print(self?.priceArray)
                                    DispatchQueue.main.async {
                                        self?.auctionTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                                    }
                                    print("更新價格 label")
                                } catch {
                                    print("latest_price error: ", error.localizedDescription)
                                }
                            } else if topData.type == "broadcast_winner" {
                                self?.auctionEnd = true
                                do {
                                    let decoder = JSONDecoder()
                                    let data = try decoder.decode(WinnerData.self, from: message)
                                    
                                    if data.data.email == self?.emailHere {
                                        // 得標
                                        print("我得標")
                                        self?.auctionSuccessPrice = data.data.finalBidPrice
                                        self?.successNotificationContent(body: "恭喜您以 \(self?.auctionSuccessPrice ?? 20) 元得標！\n 請於 24 小時內結帳：）")
                                    } else {
                                        // 未得標
                                        print("我沒得標")
                                        self?.successNotificationContent(body: "您未得標...")
                                    }
                                    print(self?.auctionSuccessPrice)
                                    print(data.data.finalBidPrice)
                                    print(data.data.email)
                                    DispatchQueue.main.async {
                                        self?.auctionTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
                                    }
                                    
                                } catch {
                                    print("broadcast_winner error: ", error.localizedDescription)
                                }
                            }
                        } catch {
                            print("top_data error: ", error.localizedDescription)
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
    }
    
    func nextTitle() {
        if marqueeTitleArray.isEmpty == false {
            marqueeIndex = (marqueeIndex + 1) % marqueeTitleArray.count
            let transition = CATransition()
            transition.duration = 0.8
            transition.type = .push
            transition.subtype = .fromRight
            marqueeLabel.text = marqueeTitleArray[marqueeIndex]
            marqueeLabel.layer.add(transition, forKey: "nextTitle")
        }
    }
    
    func successNotificationContent(body: String) {
        let content = UNMutableNotificationContent()
        content.title = "STYLiSH"
        content.subtitle = "競拍賣結束囉"
        content.body = body
//        content.badge = 1
        content.sound = UNNotificationSound.defaultCritical
        // Add an attachment to the notification content
        if let url = Bundle.main.url(forResource: "dune",
                                        withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                                url: url,
                                                                options: nil) {
                content.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("success Error")
            } else {
                print("success Success")
            }
        }
        print("success notify")
    }
    func failNotificationContent() {
//        let content = UNMutableNotificationContent()
//        content.title = "STYLiSH"
//        content.subtitle = "競拍賣結束囉"
//        content.body = "您未得標..."
////        content.badge = 1
//        content.sound = UNNotificationSound.defaultCritical
//        // Add an attachment to the notification content
//        if let url = Bundle.main.url(forResource: "dune",
//                                        withExtension: "png") {
//            if let attachment = try? UNNotificationAttachment(identifier: "dune",
//                                                                url: url,
//                                                                options: nil) {
//                content.attachments = [attachment]
//            }
//        }
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if error != nil {
//                print("fail Error")
//            } else {
//                print("fail Success")
//            }
//        }
        print("fail notify")
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

extension AuctionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = auctionTableView.dequeueReusableCell(
                withIdentifier: TimeTableViewCell.identifier) as? TimeTableViewCell
            
            cell?.secondsRemaining = Double(timeDiffArray[indexPath.row])
            cell?.setTimer()
            
            return cell!
            
        } else {
            let indexHere = indexPath.row - 1
            let cell = auctionTableView.dequeueReusableCell(
                withIdentifier: AuctionTableViewCell.identifier) as? AuctionTableViewCell
            if startTimeArray[indexHere] < Date().timeIntervalSince1970 {
                if endTimeArray[indexHere] <= Date().timeIntervalSince1970 {
                    auctionEnd = true
                } else {
                    auctionEnd = false
                }
                
                if auctionEnd == false {
                    // 競標中
                    cell?.hideView.isHidden = true
                 
                } else {
                    // 競標結束
                    cell?.hideView.isHidden = false
                    if let auctionSuccessPrice = auctionSuccessPrice {
                        let endTime = endTimeArray[indexHere]
                        let date = Date(timeIntervalSince1970: TimeInterval(endTime))
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let strDate = dateFormatter.string(from: date)
                        cell?.hideViewLabel.text = "恭喜您以 \(auctionSuccessPrice) 元得標！\n 請於 24 小時內結帳：）"
                    } else {
                        cell?.hideViewLabel.text = "您未得標"
                    }
                }
            } else {
                // 競標還沒開始
                let startTimeStamp = startTimeArray[indexHere]
                let date = Date(timeIntervalSince1970: TimeInterval(startTimeStamp))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let strDate = dateFormatter.string(from: date)
                cell?.hideViewLabel.text = "即將於 \(strDate) 開始競標"
            }
            
            cell?.addPriceBtn.setTitle("+ " + minBidUnit[indexHere], for: .normal)
                        
            cell?.productLabel.text = titleArray[indexHere]
            cell?.priceLabel.text = "NTD " + priceArray[indexHere]
            
            cell?.productImageView.loadImage(imageArray[indexHere],
                                             placeHolder: UIImage(imageLiteralResourceName: "Image_Placeholder"))
            cell?.addPriceBtn.addTarget(self, action: #selector(addPriceAction), for: .touchUpInside)
            cell?.addPriceBtn.tag = indexHere
            cell?.confirmBtn.addTarget(self, action: #selector(comfirmAction), for: .touchUpInside)
            cell?.cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            
            if totalAddAmount != 0 {
                cell?.confirmBtn.isHidden = false
                cell?.addAmountLabel.isHidden = false
                cell?.addAmountLabel.text = "+ \(totalAddAmount)"
                cell?.totalPriceLabel.isHidden = false
                cell?.totalPriceLabel.text = "以 \((Int(priceArray[indexHere]) ?? 0) + totalAddAmount) 元競標"
                cell?.cancelBtn.isHidden = false
            } else {
                cell?.addAmountLabel.isHidden = true
                cell?.totalPriceLabel.isHidden = true
                cell?.confirmBtn.isHidden = true
                cell?.cancelBtn.isHidden = true
            }
            
            return cell ?? UITableViewCell()
        }
    }
    
    @objc func addPriceAction(_ sender: UIButton) {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.auctionTableView)
        let indexPath = self.auctionTableView.indexPathForRow(at: buttonPosition)
        if let indexPath = indexPath {
            totalAddAmount += Int(minBidUnit[0]) ?? 0
            auctionTableView.reloadRows(at: [indexPath], with: .none)
        }
        print("press add btn")
    }
    
    @objc func comfirmAction(_ sender: UIButton) {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.auctionTableView)
        let indexPath = self.auctionTableView.indexPathForRow(at: buttonPosition)
        
        if let indexPath = indexPath {
            auctionTableView.reloadRows(at: [indexPath], with: .none)
        }
        
        sendBid(addAmount: totalAddAmount)
        totalAddAmount = 0
        
        LKProgressHUD.showSuccess(text: "競標成功！")
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.auctionTableView)
        let indexPath = self.auctionTableView.indexPathForRow(at: buttonPosition)
        
        totalAddAmount = 0
        
        if let indexPath = indexPath {
            auctionTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func fetchAuctionProducts() {
        let url = "http://3.24.100.29/api/1.0/auction/product"
        guard let url = URL(string: url) else {
            print("no url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let product = try JSONDecoder().decode(AuctionProductData.self, from: data)
                    print(product)
                    self.auctionDataArray.removeAll()
                    self.auctionDataArray.append(product)
                    self.auctionDataArray.first?.data.forEach {
                        self.marqueeTitleArray.append($0.title + "拍賣中" + "            " )
                        self.dispatchSemaphore.signal()
                        self.titleArray.append($0.title)
                        self.imageArray.append($0.mainImage)
                        self.minBidUnit.append(String($0.minBidUnit))
                        self.priceArray.append(String($0.startBid))

                        let currentTimeStamp = Date().timeIntervalSince1970
                        let endTimestamp = $0.endTime / 1000
                        let startTimestamp = $0.startTime / 1000
                        let timeDifferenceInSeconds = Double(endTimestamp) - currentTimeStamp
                        let minutes = Int(timeDifferenceInSeconds) / 60
                        let seconds = Int(timeDifferenceInSeconds) % 60
                        let totalSeconds = minutes * 60 + seconds
                        self.timeDiffArray.append(totalSeconds)
                        self.startTimeArray.append(TimeInterval(startTimestamp))
                        self.endTimeArray.append(TimeInterval(endTimestamp))
                        print(self.startTimeArray)
                        print(self.endTimeArray)
//                        self.startTimeArray = [Date().timeIntervalSince1970, 1694145600.0, 1694232000.0]
//                        self.endTimeArray = [Date().timeIntervalSince1970+90, 1694149200.0, 1694235600.0]
//                        self.timeDiffArray = [30, 60, 60]
                        print("auction api load done")
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
    
    private func fetchLatestPrice() {
        let jsonDictionary: [String: Any] = [
            "type": "initialize",
            "data": [
                //"email": UserDefaults.standard.string(forKey: "UserEmail") ?? "email error"
                "email": emailHere
            ] as [String: Any]
        ]
        do {
            let topData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            webSocket?.send(.data(topData)) { error in
                if let error = error {
                    print("Send error: \(error)")
                }
                self.dispatchSemaphore.signal()
            }
        } catch {
            print("latest price data JSON serialization error: \(error)")
        }
    }
}

struct AuctionProductData: Codable {
    let data: [AuctionProduct]
}

struct AuctionProduct: Codable {
    let auctionID: Int
    let category: String
    let description: String
    let endTime: Int
    let id: String
//    let imageBase64: String?
    let images: String
    let mainImage: String
    let minBidUnit: Int
    let note: String
    let place: String
    let startBid: Int
    let startTime: Int
    let source: String
    let story: String
    let texture: String
    let title: String
    let wash: String

    enum CodingKeys: String, CodingKey {
        case auctionID = "auction_id"
        case category
        case description
        case endTime = "end_time"
        case id
//        case imageBase64 = "image_base64"
        case images
        case mainImage = "main_image"
        case minBidUnit = "min_bid_unit"
        case note
        case place
        case source
        case startBid = "start_bid"
        case startTime = "start_time"
        case story
        case texture
        case title
        case wash
    }
}

struct TopData: Codable {
    var type: String
    //var data: LatestPrice
}

struct LatestPriceData: Codable {
    var type: String
    var data: LatestPrice
}

struct WinnerData: Codable {
    var type: String
    var data: Winner
}

struct LatestPrice: Codable {
    var number: Int
}

struct Winner: Codable {
    let email, auctionID, productID: String
    let finalBidPrice: Int

    enum CodingKeys: String, CodingKey {
        case email
        case auctionID = "auction_id"
        case productID = "product_id"
        case finalBidPrice = "final_bid_price"
    }
}

struct Email: Codable {
    var email: String
}

