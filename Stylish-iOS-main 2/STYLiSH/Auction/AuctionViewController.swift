//
//  AuctionViewController.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class AuctionViewController: UIViewController {
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.nextTitle()
        }
        
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


extension AuctionViewController: UITableViewDelegate {
    
}

extension AuctionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = auctionTableView.dequeueReusableCell(withIdentifier: AuctionTableViewCell.identifier) as? AuctionTableViewCell
            
            
            return cell ?? UITableViewCell()
        
    }
}
