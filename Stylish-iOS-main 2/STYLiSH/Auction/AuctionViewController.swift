//
//  AuctionViewController.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/1.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class AuctionViewController: UIViewController {

    @IBOutlet weak var auctionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auctionTableView.dataSource = self
        auctionTableView.delegate = self

        
    }

}


extension AuctionViewController: UITableViewDelegate {
    
}

extension AuctionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = auctionTableView.dequeueReusableCell(withIdentifier: MarqueeTableViewCell.identifier) as? MarqueeTableViewCell
            
            
            return cell ?? UITableViewCell()
        } else {
            let cell = auctionTableView.dequeueReusableCell(withIdentifier: AuctionTableViewCell.identifier) as? AuctionTableViewCell
            
            
            return cell ?? UITableViewCell()
        }
    }
    
    
}
