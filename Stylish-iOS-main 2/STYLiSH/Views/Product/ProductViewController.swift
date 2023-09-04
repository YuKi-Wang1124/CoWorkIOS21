//
//  ProductViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/15.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    private enum LayoutType {
        case list
        case grid
    }

    private enum ProductType: Int {
        case all = 0
        case women = 1
        case men = 2
        case accessories = 3
    }

    private struct Segue {
        static let men = "SegueMen"
        static let women = "SegueWomen"
        static let accessories = "SegueAccessories"
        static let all = "SegueAll"
    }

   
    
    @IBOutlet weak var indicatorView: UIView!

    @IBOutlet weak var indicatorCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var layoutBtn: UIBarButtonItem!

    @IBOutlet weak var menProductsContainerView: UIView!

    @IBOutlet weak var womenProductsContainerView: UIView!

    @IBOutlet weak var accessoriesProductsContainerView: UIView!
    
    @IBOutlet weak var allProductsContainerView: UIView!

    
    @IBOutlet weak var allBtn: UIButton!
    
    @IBOutlet weak var womenBtn: UIButton!
    
    @IBOutlet weak var menBtn: UIButton!
    
    @IBOutlet weak var accessoriesBtn: UIButton!
    
    
    
    private var containerViews: [UIView] {
        return [menProductsContainerView, womenProductsContainerView, accessoriesProductsContainerView, allProductsContainerView]
    }

    private var isListLayout: Bool = false {
        didSet {
            switch isListLayout {
            case true: showListLayout()
            case false: showGridLayout()
            }
        }
    }
    
    
    let searchController = UISearchController()

    @IBOutlet weak var serchView: UIView!
    
    let viewWidth = UIScreen.main.bounds.width
    let viewHeight = UIScreen.main.bounds.height
    
    var collectionView: UICollectionView! = nil
    
    var cellCount = 0
    
    private var searchDataArray = [SearchData]()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        isListLayout = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchResultsUpdater = self
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: serchView.frame.height), collectionViewLayout: generateLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        serchView.addSubview(collectionView)

        serchView.isHidden = true
       
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(330))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: - Action
    @IBAction func onChangeProducts(_ sender: UIButton) {
        
        var productBtns = [allBtn, womenBtn, menBtn, accessoriesBtn]
        
        for btn in productBtns {
            btn?.isSelected = false
        }
        sender.isSelected = true
        moveIndicatorView(reference: sender)
        
        guard let type = ProductType(rawValue: sender.tag) else { return }
        updateContainer(type: type)
    }

    @IBAction func onChangeLayoutType(_ sender: UIBarButtonItem) {
        isListLayout = !isListLayout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let productListVC = segue.destination as? ProductListViewController else { return }
        let identifier = segue.identifier
        var provider: ProductListDataProvider?
        let marketProvider = MarketProvider()
        
        if identifier == Segue.men {
            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.men,
                dataProvider: marketProvider)
        } else if identifier == Segue.women {
            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.women,
                dataProvider: marketProvider)
        } else if identifier == Segue.accessories {
            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.accessories,
                dataProvider: marketProvider)
        }  else if identifier == Segue.all {
            provider = ProductsProvider(
                productType: ProductsProvider.ProductType.all,
                dataProvider: marketProvider)
        }
        
        productListVC.provider = provider
    }

    // MARK: - Private method
    private func showListLayout() {
        layoutBtn.image = .asset(.Icons_24px_CollectionView)
        showLayout(type: .list)
    }

    private func showGridLayout() {
        layoutBtn.image = .asset(.Icons_24px_ListView)
        showLayout(type: .grid)
    }

    private func showLayout(type: LayoutType) {
        children.forEach { child in
            if let child = child as? ProductListViewController {
                switch type {
                case .list: child.showListView()
                case .grid: child.showGridView()
                }
            }
        }
    }

    private func moveIndicatorView(reference: UIView) {
        indicatorCenterXConstraint.isActive = false
        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
        indicatorCenterXConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }

    private func updateContainer(type: ProductType) {
        containerViews.forEach { $0.isHidden = true }
        
        switch type {
        case .all:
            allProductsContainerView.isHidden = false
        case .men:
            menProductsContainerView.isHidden = false
        case .women:
            womenProductsContainerView.isHidden = false
        case .accessories:
            accessoriesProductsContainerView.isHidden = false
        }
    }
}


extension ProductViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false  {
            
            
            serchView.isHidden = false
            fetchSearchProducts(text: searchText)
            
        } else {
            serchView.isHidden = true

        }
    }
}


extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell
        
        if searchDataArray.isEmpty {
            cell?.productNameLabel.text = "沒有相關商品"
        } else {
            cell?.productNameLabel.text = searchDataArray[0].data[indexPath.row].title
            cell?.priceLabel.text = "NTD" + "\(searchDataArray[0].data[indexPath.row].price)"
            cell?.imageView.loadImage(searchDataArray[0].data[indexPath.row].images[0], placeHolder: UIImage(imageLiteralResourceName: "Image_Placeholder"))
        }
        return cell ?? UICollectionViewCell()
    }

    private func fetchSearchProducts(text: String) {
        let baseURL = "http://3.24.100.29/api/1.0/products/search"
        let keywordEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?keyword=\(keywordEncoded)"
        guard let url = URL(string: urlString) else {
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
                    let product = try JSONDecoder().decode(SearchData.self, from: data)
                    self.searchDataArray.removeAll()
                    self.searchDataArray.append(product)
                    DispatchQueue.main.async {
                        self.cellCount = product.data.count
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}


