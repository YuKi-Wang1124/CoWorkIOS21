//
//  MapViewController.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    let northStore = [
        StoreInfo(storeName: TestStoreInfoEnum.first.storeName, phoneNimber: TestStoreInfoEnum.first.phoneNimber, address: TestStoreInfoEnum.first.address),
        StoreInfo(storeName: TestStoreInfoEnum.second.storeName, phoneNimber: TestStoreInfoEnum.second.phoneNimber, address: TestStoreInfoEnum.second.address)
    ]
    
    let westStore = [
        StoreInfo(storeName: TestStoreInfoEnum.third.storeName, phoneNimber: TestStoreInfoEnum.third.phoneNimber, address: TestStoreInfoEnum.third.address),
    ]
    
    let southStore = [
        StoreInfo(storeName: TestStoreInfoEnum.fourth.storeName, phoneNimber: TestStoreInfoEnum.fourth.phoneNimber, address: TestStoreInfoEnum.fourth.address),
    ]
    
    let eastStore = [
        StoreInfo(storeName: TestStoreInfoEnum.fifth.storeName, phoneNimber: TestStoreInfoEnum.fifth.phoneNimber, address: TestStoreInfoEnum.fifth.address),
    ]

    var dataSource: UITableViewDiffableDataSource<Location, StoreInfo>!
    var snapshot = NSDiffableDataSourceSnapshot<Location, StoreInfo>()
    
    var tableView = {
        var tbView = UITableView()
        tbView.rowHeight = UITableView.automaticDimension
        tbView.separatorStyle = .singleLineEtched
        tbView.translatesAutoresizingMaskIntoConstraints = false
        tbView.register(MapTableViewHeaderFooterView.self,  forHeaderFooterViewReuseIdentifier: MapTableViewHeaderFooterView.reuseIdentifier)
        tbView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        return tbView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        setUI()
        updateTableViewDataSource()
    }
    
    func setUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateTableViewDataSource() {
        dataSource = UITableViewDiffableDataSource<Location, StoreInfo>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as? MapTableViewCell
            cell?.storeNameLabel.text = itemIdentifier.storeName
            
            let phoneAttributedString = NSMutableAttributedString(string: "\(itemIdentifier.phoneNimber)")
            phoneAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: phoneAttributedString.length))
            cell?.phoneNumberBtn.setAttributedTitle(phoneAttributedString, for: .normal)
            
            let attributedString = NSMutableAttributedString(string: itemIdentifier.address)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            cell?.addressBtn.setAttributedTitle(attributedString, for: .normal)
            
            cell?.selectionStyle = .none
            return cell!
        }
        
        tableView.dataSource = dataSource
        snapshot = NSDiffableDataSourceSnapshot<Location, StoreInfo>()
        snapshot.appendSections([.north, .east, .west, .south])
        snapshot.appendItems(northStore, toSection: .north)
        snapshot.appendItems(westStore, toSection: .west)
        snapshot.appendItems(southStore, toSection: .south)
        snapshot.appendItems(eastStore, toSection: .east)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MapViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MapTableViewHeaderFooterView.reuseIdentifier) as? MapTableViewHeaderFooterView else {
            return nil
        }
        
        let northIndex = Location.north.rawValue
        let westIndex = Location.west.rawValue
        let southIndex = Location.south.rawValue
        let eastIndex = Location.east.rawValue

        let locationArray = [northIndex, westIndex, southIndex, eastIndex]
        
        headerView.sectionLabel.text = locationArray[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myMapVC = MyMapViewController()
        
        if indexPath.section == 0 {
            myMapVC.address = snapshot.itemIdentifiers[indexPath.row].address
        } else if indexPath.section == 1 {
            myMapVC.address = snapshot.itemIdentifiers(inSection: snapshot.sectionIdentifiers[1])[indexPath.row].address
        } else if indexPath.section == 2 {
            myMapVC.address = snapshot.itemIdentifiers(inSection: snapshot.sectionIdentifiers[2])[indexPath.row].address
        } else if indexPath.section == 3 {
            myMapVC.address = snapshot.itemIdentifiers(inSection: snapshot.sectionIdentifiers[3])[indexPath.row].address
        }
        
        navigationController?.pushViewController(myMapVC, animated: true)
    }
    
}

// MARK: - data sourece

enum Location: String, CaseIterable {
    case north = "北部"
    case west = "中部"
    case south = "南部"
    case east = "東部"
}

struct StoreInfo: Hashable {
    var storeName: String
    var phoneNimber: Int
    var address: String
}

enum TestStoreInfoEnum {
    case first, second, third, fourth, fifth
    
    var storeName: String {
        switch self {
        case .first:
            return "市府店"
        case .second:
            return "大安店"
        case .third:
            return "台中店"
        case .fourth:
            return "台南店"
        case .fifth:
            return "台東店"
        }
    }
    
    var phoneNimber: Int {
        switch self {
        case .first:
            return 023456781
        case .second:
            return 023456782
        case .third:
            return 023456783
        case .fourth:
            return 023456784
        case .fifth:
            return 023456785
        }
    }
    
    var address: String {
        switch self {
        case .first:
            return "臺北市信義區市府路1號"
        case .second:
            return "100台北市中正區仁愛路二段99號"
        case .third:
            return "台中市西屯區臺灣大道三段99號"
        case .fourth:
            return "臺南市安平區永華路二段6號"
        case .fifth:
            return "臺東市中山路276號"
        }
    }
}

