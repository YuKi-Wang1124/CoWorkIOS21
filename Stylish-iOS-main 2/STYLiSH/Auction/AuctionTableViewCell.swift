//
//  AuctionTableViewCell.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class AuctionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hideView: UIView!
    
    @IBOutlet weak var hideViewLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addPriceBtn: UIButton!
    
    @IBOutlet weak var addAmountLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!

    var countdownTimer: Timer?
    var secondsRemaining = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        print("a: ",secondsRemaining)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("c: ",secondsRemaining)
        if secondsRemaining != 0 {
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            print("b: ",secondsRemaining)
        }
    }
    
    @objc func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            updateCountdownLabel()
        } else {
            countdownTimer?.invalidate()
            createNotificationContent()
        }
    }
    
    func updateCountdownLabel() {
        let hours = secondsRemaining / 60 / 60
        let minutes = secondsRemaining / 60 % 60
        let seconds = secondsRemaining % 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func createNotificationContent() {
        let content = UNMutableNotificationContent()
        content.title = "STYLiSH"
        content.subtitle = (productLabel.text ?? "") + "競拍賣結束囉"
        content.body = (productLabel.text ?? "") + "競拍結束囉，來看看自己得標了沒"
//        content.badge = 1
        content.sound = UNNotificationSound.defaultCritical
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
